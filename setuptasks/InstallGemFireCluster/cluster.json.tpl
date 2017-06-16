{
    "global-properties":{
        "gemfire": "/runtime/gemfire",
        "java-home" : "/runtime/java",
        {% for Server in Servers  if "Locator" in Server.Roles and Server.PrivateIP == '192.168.1.101' %}
        "locators" : "{{ Server.PublicHostName }}[10000]",
    	{% endfor %}
        "cluster-home" : "/runtime/gem_cluster_1",
        "distributed-system-id": 1
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
        "jvm-options" : ["-Xmx2g","-Xms2g", "-XX:+UseConcMarkSweepGC", "-XX:+UseParNewGC"]
    },
   "datanode-properties" : {
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
        "enable-network-partition-detection" : "true"
    },
    "hosts": {
    {% for Server in Servers  if "DataNode" in Server.Roles or "Locator" in Server.Roles %}
        "ip-{{ Server.PrivateIP | replace('.','-') }}" : {
            "host-properties" :  {
             },
             "processes" : {
               {% if Server.PrivateIP == '192.168.1.101' %}
                "{{ Server.Name }}-locator" : {
                    "type" : "locator",
                    "jmx-manager-hostname-for-clients" : "{{ Server.PublicHostName }}",
                    "jmx-manager-start" : "true"
                 },
               {% endif %}
                "{{ Server.Name }}-server" : {
                    "type" : "datanode",
                    "jvm-options" : ["-Xmx{{ Server.XMX }}m","-Xms{{ Server.XMX }}m","-Xmn{{ Server.XMN }}m", "-XX:+UseConcMarkSweepGC", "-XX:+UseParNewGC", "-XX:CMSInitiatingOccupancyFraction=85"]
                    {% if Server.PrivateIP == '192.168.2.101' %}
                    , "http-service-port": 18080,
                    "start-dev-rest-api" : "true"
                    {% endif %}
                 }
             },
             "ssh" : {
                "host" : "{{ Server.PublicIP }}",
                "user" : "{{ Server.SSHUser }}",
                "key-file" : "{{ SSHKeyPath }}"
             }
        } {% if not loop.last -%},{%- endif %}
    {% endfor %}
   }
}
