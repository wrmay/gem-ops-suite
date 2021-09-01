{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    {######### VPC Definitions #############}
    "SecurityGroup":{
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
         "GroupDescription" : "{{ EnvironmentName }}SecurityGroup",
         "VpcId" : "vpc-09575f1fdf7a3b90c",
         {#####  When No Egress Rules are Specified Default Allows All #####}
         "SecurityGroupIngress" : [
            {
              "IpProtocol" : "-1",
               "CidrIp" : "10.53.0.0/16"
            },
            {
              "IpProtocol" : "tcp",
               "FromPort" : "17070",
               "ToPort" : "17070",
               "CidrIp" : "0.0.0.0/0"
            }
          ],
          "Tags" : [
            {
              "Key": "Name",
              "Value" : "{{ EnvironmentName }}SecurityGroup"
            }
          ]
      }

    },
    {######### Server Definitions ###########}
    {% for Server in Servers %}
    "{{ Server.Name }}" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
         "AvailabilityZone" : "us-east-1b",
         {% if Server.InstanceType.startswith('m4') %}
         "EbsOptimized" : true,
         {% else%}
         "EbsOptimized" : false,
         {% endif %}
         "ImageId" : "ami-0503fae4f316477fb",
         "InstanceInitiatedShutdownBehavior" : "stop",
         "InstanceType" : "{{ Server.InstanceType }}",
         "KeyName" : "{{ KeyPair }}",
         "PrivateIpAddress" : "{{ Server.PrivateIP }}",
         "SecurityGroupIds" : [ { "Ref" : "SecurityGroup"},"sg-0662302ce5dbefa74"],
         "SubnetId" :"subnet-04a03ae3e7ed8225d",
         "Tags" : [
            {
              "Key": "Name",
              "Value" : "{{ EnvironmentName }}Server{{ Server.Name }}"
            },
            {
              "Key": "Environment",
              "Value" : "{{ EnvironmentName }}"
            }
          ],
          {#### ESB Volumes Are Attached Here ####}
         "Volumes" : [
         {% for Device in Server.BlockDevices if Device.DeviceType == 'EBS' %}
          {
            "Device" : "{{ Device.Device }}",
            "VolumeId" : "{{ Device.EBSVolumeId }}"
          }
        {% if not loop.last %},{% endif %}
        {% endfor %}
         ] ,
         {#### Ephemeral Volumes are Mapped Here ####}
         "BlockDeviceMappings" : [
         {% for Device in Server.BlockDevices if Device.DeviceType == 'Ephemeral' %}
            {
              "DeviceName" : "{{ Device.Device }}",
              "VirtualName" : "ephemeral{{ loop.index0 }}"
            } {% if not loop.last %},{% endif %}
          {% endfor %}
         ]
      }
    }
    {% if not loop.last %}, {% endif %}
    {% endfor %}
  },
  "Description": "{{ EnvironmentName }} Stack"
}
