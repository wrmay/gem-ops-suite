{
    "EnvironmentName" : "{{ EnvironmentName }}",
    "RegionName" : "us-east-1",
    "KeyPair" : "{{ SSHKeyPairName }}",
    "SSHKeyPath" : "{{ SSHKeyPath }}",
    {% if Environment %}
    "Environment" : {
    {% for key,d in Environment.items() %}
      "{{ key }}" : {
    {%for k,v in d.items() %}
          "{{ k }}" : "{{ v }}" {% if not loop.last -%},{% endif %}
    {% endfor %}
  } {% if not loop.last -%},{%- endif %}
    {% endfor %}
    },
    {% endif %}
    "Servers" : [
    {% for Server in Servers %}
        {
            "Name" : "{{ Server.Name }}",
            "ImageId" : "ami-dc4862a3",
            "InstanceType" : "{{ Server.InstanceType }}",
            "PrivateIP" : "{{ Server.PrivateIP }}",
            "AZ" : "{{ Server.AZ }}",
            "SSHUser" : "ec2-user",
            "XMX" : "{{ Server.XMX }}",
            "XMN" : "{{ Server.XMN }}",
            "Roles" : [ {% for Role in Server.Roles -%}"{{ Role }}"{%if not loop.last -%},{%- endif %}{%- endfor %}],
            "BlockDevices" : [
              {
                  "Size": 10,
                  "Device" : "/dev/xvdf",
                  "MountPoint" : "/runtime",
                  "Owner" : "ec2-user",
                  "FSType" : "ext4",
                  "DeviceType" : "EBS",
                  "EBSVolumeType" : "gp2"
    {% if "DataNode" in Server.Roles %}
              },
              {
                  "Size": {{ Server.RAM * 2 }},
                  "Device" : "/dev/xvdg",
                  "MountPoint" : "/data",
                  "Owner" : "ec2-user",
                  "FSType" : "ext4",
                  "DeviceType" : "EBS",
                  "EBSVolumeType" : "gp2"
              },
              {
                  "Size": {{ Server.RAM * 4 }},
                  "Device" : "/dev/xvdh",
                  "MountPoint" : "/backup",
                  "Owner" : "ec2-user",
                  "FSType" : "ext4",
                  "DeviceType" : "EBS",
                  "EBSVolumeType" : "gp2"
      {% endif %}
              }
            ],
            "Installations" : [
                {
                    "Name": "AddHostEntries"
                },
                {
                    "Name": "MountStorage"
                },
                {
                    "Name": "YumInstallPackages",
                    "Packages": ["java-1.8.0-openjdk-devel.x86_64"]
                },
                {
                    "Name" : "CopyArchives",
                    "Archives" : [
                        {
                            "Name" : "GemFire 9.3.0",
                            "ArchiveURL" : "http://download.pivotal.com.s3.amazonaws.com/gemfire/9.3.0/pivotal-gemfire-9.3.0.zip",
                            "RootDir" : "pivotal-gemfire-9.3.0",
                            "UnpackInDir" : "/runtime",
                            "LinkName" : "gemfire"
                        }
                        , {
                            "Name" : "Apache Maven 3.3.9",
                            "ArchiveURL" : "https://s3-us-west-2.amazonaws.com/rmay.pivotal.io.software/apache-maven-3.3.9-bin.tar.gz",
                            "RootDir" : "apache-maven-3.3.9",
                            "UnpackInDir" : "/runtime",
                            "LinkName" : "maven"
                        }
                    ]
                },
                {
                    "Name" : "ConfigureProfile",
                    "Owner" : "ec2-user"
                }
                ,{
                  "Name" : "ConfigureMaven",
                  "Owner" : "ec2-user"
                }
                {% if  "DataNode" in Server.Roles or "Locator" in Server.Roles %}
                ,
                {
                    "Name" : "InstallGemFireCluster",
                    "ClusterHome" : "/runtime/gem_cluster_1",
                    "AdditionalFiles" : ["cluster.py","clusterdef.py","gemprops.py", "gf.py"]
                },
                {
                  "Name" : "InstallGemFireToolkit",
                  "AdditionalFiles" : ["gemfire-toolkit"],
                  "ClusterHome" : "/runtime/gem_cluster_1",
                  "Owner" : "ec2-user"
                }
                {% endif %}
                {% if "ETL" in Server.Roles %}
                , {
                    "Name" : "people-loader",
                    "TargetDir" : "/runtime/people-loader",
                    "Owner" : "ec2-user"
                }
                {% endif %}
            ]
        } {%if not loop.last -%},{%- endif %}
        {% endfor %}
    ]
}
