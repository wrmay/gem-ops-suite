{
    "EnvironmentName" : "{{ EnvironmentName }}",
    "RegionName" : "{{ RegionName }}",
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
            "ImageId" : "ami-0443305dabd4be2bc",
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
            "Installations" : []
        } {%if not loop.last -%},{%- endif %}
        {% endfor %}
    ]
}
