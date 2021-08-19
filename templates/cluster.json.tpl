{
    "global-properties":{
        "gemfire": "/runtime/gemfire",
        "java-home" : "/etc/alternatives/jre-11-openjdk",
        "locators" : "{% for Server in Servers  if "Locator" in Server.Roles -%}{{Server.PublicHostName}}[10000]{% if not loop.last -%},{%- endif %}{%- endfor %}",
        "cluster-home" : "/runtime/gem_cluster_1",
        "distributed-system-id": 1
        {% if Environment and Environment.GemFire %}
        {% for key,val in Environment.GemFire if key.startswith('global-properties-') %}
        , "{{ key.substring(len('global-properties-')) }}" : "{{ val }}"
        {% endfor %}
        {% endif %}
    },
   "locator-properties" : {
        "port" : 10000,
        "jmx-manager-port" : 11099,
        "http-service-port" : 17070,
        "jmx-manager" : "true",
        "log-level" : "config",
        "statistic-sampling-enabled" : "true",
        "statistic-archive-file" : "locator.gfs",
        "log-file-size-limit" : "10",
        "log-disk-space-limit" : "100",
        "archive-file-size-limit" : "10",
        "archive-disk-space-limit" : "100",
        "enable-network-partition-detection" : "true",
        "jvm-options" : ["-Xmx2g","-Xms2g", "-XX:+UseConcMarkSweepGC"]
        {% if Environment and Environment.GemFire %}
        {% for key,val in Environment.GemFire if key.startswith('locator-properties-') %}
        , "{{ key.substring(len('locator-properties-')) }}" : "{{ val }}"
        {% endfor %}
        {% endif %}
    },
   "datanode-properties" : {
        "cache-xml-file" : "../cache.xml",
        "conserve-sockets" : false,
        "log-level" : "config",
        "membership-port-range" : "10901-10999",
        "statistic-sampling-enabled" : "true",
        "statistic-archive-file" : "datanode.gfs",
        "log-file-size-limit" : "10",
        "log-disk-space-limit" : "100",
        "archive-file-size-limit" : "10",
        "archive-disk-space-limit" : "100",
        "tcp-port" : 10001,
        "server-port" : 10100,
        "gemfire.ALLOW_PERSISTENT_TRANSACTIONS" : "true",
        "enable-network-partition-detection" : "true"
        {% if Environment and Environment.GemFire %}
        {% for key,val in Environment.GemFire if key.startswith('datanode-properties-') %}
        , "{{ key.substring(len('datanode-properties-')) }}" : "{{ val }}"
        {% endfor %}
        {% endif %}
    },
    "hosts": {
    {% for Server in Servers  if "DataNode" in Server.Roles or "Locator" in Server.Roles %}
        "ip-{{ Server.PrivateIP | replace('.','-') }}.{{ RegionName }}.compute.internal" : {
            "host-properties" :  {
             },
             "processes" : {
               {% if "Locator" in Server.Roles %}
                "{{ Server.Name }}-locator" : {
                    "type" : "locator",
                    "jmx-manager-hostname-for-clients" : "{{ Server.PublicHostName }}"
                    {% if "Pulse" in Server.Roles %}
                    , "jmx-manager-start" : "true"
                    {% endif %}
                 }
               {% endif %}
               {%if "DataNode" in Server.Roles %}
                {% if "Locator" in Server.Roles -%},{% endif %}"{{ Server.Name }}-server" : {
                    "type" : "datanode",
                    "jvm-options" : [
                        "-Xss100m",
                        "-XX:SurvivorRatio=1",
                        "-XX:MaxTenuringThreshold=2",
                        "-XX:ConcGCThreads=2",
                        "-Xmx12g",
                        "-Xms12g",
                        "-XX:+HeapDumpOnOutOfMemoryError",
                        "-XX:HeapDumpPath=jvmdumps",
                        "-Xlog:gc*,age*=debug,ergo*=debug:gc.log:time:filecount=10,filesize=10k",
                        "-XX:NewSize=1536m",
                        "-XX:MaxNewSize=1536m",
                        "-XX:+UseConcMarkSweepGC",
                        "-XX:+CMSClassUnloadingEnabled",
                        "-XX:CMSInitiatingOccupancyFraction=80",
                        "-XX:+UseCMSInitiatingOccupancyOnly",
                        "-XX:+ExplicitGCInvokesConcurrent",
                        "-XX:+UnlockDiagnosticVMOptions",
                        "-XX:+ScavengeBeforeFullGC",
                        "-XX:+CMSScavengeBeforeRemark",
                        "-XX:+CMSParallelRemarkEnabled",
                        "-XX:+AlwaysPreTouch"]
                    {% if "REST" in Server.Roles %}
                    , "http-service-port": 18080,
                    "start-dev-rest-api" : "true"
                    {% endif %}
                 }
              {% endif %}
             },
             "ssh" : {
                "host" : "{{ Server.PublicHostName }}",
                "user" : "{{ Server.SSHUser }}",
                "key-file" : "{{ SSHKeyPath }}"
             }
        } {% if not loop.last -%},{%- endif %}
    {% endfor %}
   }
}
