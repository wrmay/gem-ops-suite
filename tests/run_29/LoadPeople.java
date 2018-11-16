package io.pivotal.pde.sample;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.geode.cache.CacheFactory;
import org.apache.geode.cache.Region;
import org.apache.geode.cache.client.ClientCache;
import org.apache.geode.cache.client.ClientCacheFactory;
import org.apache.geode.cache.client.ClientRegionShortcut;
import org.apache.geode.pdx.PdxSerializer;
import org.apache.geode.pdx.ReflectionBasedAutoSerializer;

import io.pivotal.pde.nopdx.PersonKey;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LoadPeople {

//	private static int batchSize = 100;

	private static int parseIntArg(String in, String message){
    	int result = 0;

    	try{
    		result = Integer.parseInt(in);
    	} catch(NumberFormatException nfx){
    		System.err.println(message);
    		System.exit(1);
    	}
		return result;
	}

	private static void printUsage(){
		System.out.println("usage: LoadPeople --locator=host[port] --region=RegionName --count=2000 --sleep=100 --threads=10 --keys=1000");
		System.out.println("       only --locator and --count are required");
		System.out.println("       --sleep is in milliseconds");
		System.out.println("       --threads may not exceed 64");
		System.out.println("       --keys is the total number of entries");
		System.out.println("       --partition-by-zip (optional)");
	}

	private static String REGION_ARG="--region=";
	private static String PARTITION_ARG="--partition-by-zip";
	private static String LOCATOR_ARG="--locator=";
	private static String COUNT_ARG = "--count=";
    private static String RUNTIME_ARG = "--run-time=";
	private static String SLEEP_ARG = "--sleep=";
	private static String THREADS_ARG = "--threads=";
	private static String USERNAME_ARG = "--username=";
	private static String PASSWORD_ARG = "--password=";
	private static String KEYS_ARG = "--keys=";
	private static Pattern LOCATOR_PATTERN= Pattern.compile("(\\S+)\\[(\\d{1,5})\\]");

	private static String regionName = "Person";
	private static String locatorHost = "";
	private static int locatorPort = 0;
	private static int count = 0;
	private static int runtime = 0;
	private static int sleep = 0;
	private static int threads = 1;
	private static int keys = 0;
	private static Region personRegion;
	private static boolean partitionByZip = false;

	private static int POOL_IDLE_TIMEOUT = 10;
	private static int POOL_READ_TIMEOUT = 2000;
	private static int POOL_MAX_CONNECTIONS = 50;
	private static int POOL_FREE_CONNECTION_TIMEOUT=2000;

	// intentionally package scope
	static String username = "";
	static String password = "";

    static Logger log = LogManager.getLogger("TEST");


	public static void main( String[] args )
    {
		if (args.length == 0){
			printUsage();
			System.exit(1);
		}

    	for(String arg:args){
    		if (arg.startsWith(LOCATOR_ARG)){
    			String val = arg.substring(LOCATOR_ARG.length());
    			Matcher m = LOCATOR_PATTERN.matcher(val);
    			if (!m.matches()){
    				System.out.println("argument \"" + val + "\" does not match the locator pattern \"host[port]\"");
    				System.exit(1);
    			} else {
    				locatorHost = m.group(1);
    				locatorPort = parseIntArg(m.group(2), "locator port must be a number");
    			}
    		} else if (arg.startsWith(REGION_ARG)) {
    			regionName = arg.substring(REGION_ARG.length());
    		} else if (arg.startsWith(COUNT_ARG)) {
    			String val = arg.substring(COUNT_ARG.length());
    			count = parseIntArg(val, "count argument must be a number");
            } else if (arg.startsWith(RUNTIME_ARG)) {
                String val = arg.substring(RUNTIME_ARG.length());
                runtime = parseIntArg(val, "run time argument must be a number");
			} else if (arg.startsWith(KEYS_ARG)) {
				String val = arg.substring(KEYS_ARG.length());
				keys = parseIntArg(val, "keys argument must be a number");
    		} else if (arg.startsWith(SLEEP_ARG)){
    			String val = arg.substring(SLEEP_ARG.length());
    			sleep = parseIntArg(val, "sleep argument must be a number");
    		} else if (arg.startsWith(THREADS_ARG)){
    			String val = arg.substring(THREADS_ARG.length());
    			threads = parseIntArg(val, "threads argument must be a number");
    		} else if (arg.equals(PARTITION_ARG)){
    			partitionByZip = true;
    		} else if (arg.startsWith(USERNAME_ARG)){
    			username = arg.substring(USERNAME_ARG.length());
    		} else if (arg.startsWith(PASSWORD_ARG)){
    			password = arg.substring(PASSWORD_ARG.length());
    		} else {
    			System.out.println("unrecognized argument: " + arg);
    			System.exit(1);
    		}
    	}

    	if (locatorHost.length() == 0){
    		System.out.println("--locator argument is required");
    		System.exit(1);
    	}

    	if (count == 0){
    		System.out.println("--count argument is required");
    		System.exit(1);
    	}

    	if (count <= 0 || threads <= 0){
    		System.out.println("count and threads arguments must be strictly positive");
    		System.exit(1);
    	}

    	if (sleep < 0){
    		System.out.println("sleep argument may not be negative");
    		System.exit(1);
    	}

    	PdxSerializer serializer = new ReflectionBasedAutoSerializer("io.pivotal.pde.sample.*");
    	Properties cacheProps = new Properties();
    	cacheProps.setProperty("security-client-auth-init", "io.pivotal.pde.sample.StaticAuthInit");
    	cacheProps.setProperty("log-file", "peopleloader.log");
        cacheProps.setProperty("log-level", "info");
    	ClientCache cache = new ClientCacheFactory(cacheProps)
                .setPdxSerializer(serializer)
                .addPoolLocator(locatorHost, locatorPort)
				.setPoolMaxConnections(POOL_MAX_CONNECTIONS)
				.setPoolFreeConnectionTimeout(POOL_FREE_CONNECTION_TIMEOUT)
                .setPoolIdleTimeout(POOL_IDLE_TIMEOUT)
                .setPoolReadTimeout(POOL_READ_TIMEOUT).create();

//    	ClientCache cache = new ClientCacheFactory().addPoolLocator(locatorHost, locatorPort).create();
		personRegion = cache.createClientRegionFactory(ClientRegionShortcut.PROXY).create(regionName);

        // if we set no run-time then wait forever
        long stopBy = runtime > 0 ? System.currentTimeMillis() + (1000 * runtime) : Long.MAX_VALUE;

        // start the workers
		Worker []workers = new Worker[threads];
		for(int i=0;i<threads; ++i){
			workers[i] = new Worker(i, stopBy);
			workers[i].start();
		}

		// start a reporter thread
        Thread reportThread = new Thread(){

            @Override
            public void run() {
                while(true){
                    try {
                        Thread.sleep(20000);
                    } catch (InterruptedException x) {
                        //
                    }

                    int s = 0;
                    int f = 0;
                    for(Worker w: workers){
                        s += w.getSuccesses();
                        f += w.getFailures();
                    }
                    log.info("SUCCESSES: {}  FAILURES: {}", s, f);
                }
            }
        };
		reportThread.setDaemon(true);
		reportThread.start();

        for(int i=0;i<threads; ++i){
            long wait = stopBy - System.currentTimeMillis();
            wait = wait > 0 ? wait + 1000 : 1000;
            try {
                workers[i].join(wait);
                if (workers[i].isAlive())
                    System.out.println("THREAD IS STUCK");
                successes += workers[i].getSuccesses();
                failures += workers[i].getFailures();
            } catch(InterruptedException x){
                //
            }
        }

		personRegion.close();
		cache.close();

		System.out.println("SUCCESSES: " + successes);
        System.out.println("FAILURES: " + failures);
    }

	private static int successes = 0;
	private static int failures = 0;

    private synchronized static void report(boolean success){
        if (success)
            successes += 1;
        else
            failures +=1;
    }

	private static class Worker extends Thread {
		private int slice;
		private Random rand;
        private AtomicLong deadline;
        private int successes;
        private int failures;


		public Worker(int s, long deadline){
			super();
			this.setDaemon(runtime > 0);
			this.slice = s;
			this.rand = new Random();
			this.deadline = new AtomicLong(deadline);
			this.successes = 0;
			this.failures = 0;
		}

        public int getSuccesses() {
            return successes;
        }

        public int getFailures() {
            return failures;
        }

        @Override
		public void run(){
			// bring on a new batch of 10 every 30s
//			int wave = slice / 10;
//			if (wave > 0){
//			    try {
//                    Thread.sleep(30 * 1000 * wave);
//                } catch(InterruptedException x){
//			        //
//                }
//            }
			Person p = null;

			    // This thread will exit when it is stopped or when it has performed count operations

                //Map<Object, Person> batch = new HashMap<Object,Person>(batchSize);
                for (int i = slice; i < count; i += threads) {
                    if (System.currentTimeMillis() > this.deadline.get()) break;  //BREAK

                    try {
                        p = Person.fakePerson();
                        if (partitionByZip) {
                            p.setId(new PersonKey(i, p.getAddress().getZip()));
                            personRegion.put(new PersonKey(i, p.getAddress().getZip()), p);
                        } else {
                            if (keys > 0)
                                p.setId(Integer.valueOf(rand.nextInt(keys)));
                            else
                                p.setId(Integer.valueOf(i));

                            personRegion.put(p.getId(), p);
                        }
                        this.successes += 1;
                    } catch(Exception x){
                        log.error(x);
                        this.failures += 1;
                    }
                    if (sleep > 0) {
                        try {
                            Thread.sleep(sleep);
                        } catch (InterruptedException x) {
                            // ok
                        }
                    }
                }
		}
	}
	
}
