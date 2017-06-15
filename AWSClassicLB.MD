# AWSCLassicLB

This branch is an experiment to determine whether a GemFire cluster can 
function with dynamic IP addresses for the locators.  Vanguard has completely
automated GemFire on AWS clusters and the preferred method involves 
starting locators in auto-scaling groups and there is no good way to 
have a different configuration for each instance.  This includes the IP 
address which cannot be known ahead of time for this reason (or we are 
assuming this for the purpose of the experiment).

This project attempts to solve the issue by putting the locators behind 
a classic load balancer (this is an AWS sockets level reverse proxy). 

The key settings:

- All servers and locators have an /etc/hosts entry with the public name
and the private IP address of the server.  This affects how gemfire
advertises members to the world and since, on AWS, the public name resolves 
to the private IP address when inside the VPC and to the public IP address
when outside, this allows clients inside and out to access the cluster.  
This may not be an essential part of the solution, that has not been tested
yet
- locators setting: all members have a locators setting pointing to the 
classLB public name.
- locators do not set "jmx-manager-hostname-for-clients"

# Results so Far
This approach was tested with a simple client running within the VPC and 
seemed at first glance to work well.  The client was able to continue 
functioning normally as locators were started and stopped.  The client
was even able to function when no locators were running.

# Walk Through

- python3 generateAWSCluster.py
- python3 aws_provision_storage.py
- python3 aws_provision.py

At this point it is necessary to observe the public name of the LB in 
the AWS console and edit _config/env.json_. Add a key at the top called 
ELB with the name of the ELB (see below)

```json
{
    "EnvironmentName" : "ELBLocatorTest",
    "RegionName" : "us-east-1",
    "KeyPair" : "yak-keypair",
    "SSHKeyPath" : "/Users/rmay/Downloads/yak-keypair.pem",
    "ELB" : "ELBLocatorTestELB-1770481995.us-east-1.elb.amazonaws.com",
    "Servers" : [
        {
...
}
```

- finally, run python3 setup.py to install the cluster (this takes a while!)

The following members are installed and configured:

- gem1101: locator in AZ A
- gem2101: locator in AZ B
- gem3101: locator in AZ C
- gem1102: data node in AZ A
- gem2102: data node in AZ B
- gem3102: data node in AZ C
- getl3201: test client machine

The individual cluster members can be started and stopped using the _gf.py_ 
script.  For example:

```
python3 gf.py start gem1101-locator
python3 gf.py start gem1102-server
python3 gf.py start gem1102-locator
...
python3 gf.py stop gem1101-locator
```

The test was executed from _getl3201_ which has a program on it called 
people-loader.  

```
python3 ssh.py ec2-user@getl3201
...
... on getl3201
...
cd /runtime/people-loader
/runtime/apache-maven-3.3.9/bin/mvn package
python35 peopleloader.py  --locator=ELB_NAME_HERE[10000] --count=100000 --sleep=3000
```

Locators were started and stopped while this client was running.
Although messages were printed to the console, the program continued to function 
normally.