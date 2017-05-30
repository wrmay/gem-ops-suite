{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    {######### VPC Definitions #############}
    "VPC" : {
       "Type" : "AWS::EC2::VPC",
       "Properties" : {
          "CidrBlock" : "192.168.0.0/16",
          "EnableDnsHostnames" : "true",
          "EnableDnsSupport" : "true",
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}VPC"
            }
          ]
       }
    },
    "SubnetA" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}a",
         "CidrBlock" : "192.168.1.0/25",
         "MapPublicIpOnLaunch" : false,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}SubnetA"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "PublicSubnetA" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}a",
         "CidrBlock" : "192.168.1.128/25",
         "MapPublicIpOnLaunch" : true,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}PublicSubnetA"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "SubnetB" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}b",
         "CidrBlock" : "192.168.2.0/25",
         "MapPublicIpOnLaunch" : false,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}SubnetB"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "PublicSubnetB" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}b",
         "CidrBlock" : "192.168.2.128/25",
         "MapPublicIpOnLaunch" : true,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}PublicSubnetB"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "SubnetC" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}c",
         "CidrBlock" : "192.168.3.0/25",
         "MapPublicIpOnLaunch" : false,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}SubnetC"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "PublicSubnetC" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}c",
         "CidrBlock" : "192.168.3.128/25",
         "MapPublicIpOnLaunch" : true,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{ EnvironmentName }}PublicSubnetC"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "InternetGateway":{
      "Type" : "AWS::EC2::InternetGateway",
      "Properties" : {
        "Tags" : [
          {
            "Key": "Name",
            "Value": "{{ EnvironmentName }}InternetGateway"
          }
        ]
      }
    },
    "RouteTable" : {
      "Type" : "AWS::EC2::RouteTable",
      "Properties" : {
        "VpcId" : {"Ref": "VPC"},
        "Tags" : [
          {
            "Key": "Name",
            "Value" : "{{ EnvironmentName }}RouteTable"
          }
        ]
      }
    },
    "RouteToInternet" : {
      "Type" : "AWS::EC2::Route",
      "Properties" : {
        "DestinationCidrBlock" : "0.0.0.0/0",
        "GatewayId" : {"Ref": "InternetGateway"},
        "RouteTableId" : {"Ref":  "RouteTable"}
      },
      "DependsOn": ["VPCGatewayAttachment"]
    },
    "PublicSubnetARouteTableAssociation" : {
      "Type" : "AWS::EC2::SubnetRouteTableAssociation",
      "Properties" : {
         "RouteTableId" : {"Ref" : "RouteTable"},
         "SubnetId" : {"Ref" : "PublicSubnetA"}
      }
    },
    "PublicSubnetBRouteTableAssociation" : {
      "Type" : "AWS::EC2::SubnetRouteTableAssociation",
      "Properties" : {
         "RouteTableId" : {"Ref" : "RouteTable"},
         "SubnetId" : {"Ref" : "PublicSubnetB"}
      }
    },
    "PublicSubnetCRouteTableAssociation" : {
      "Type" : "AWS::EC2::SubnetRouteTableAssociation",
      "Properties" : {
         "RouteTableId" : {"Ref" : "RouteTable"},
         "SubnetId" : {"Ref" : "PublicSubnetC"}
      }
    },
    "VPCGatewayAttachment":{
      "Type" : "AWS::EC2::VPCGatewayAttachment",
      "Properties" : {
         "InternetGatewayId" : {"Ref" : "InternetGateway"  },
         "VpcId" : {"Ref" : "VPC"}
      }
    },
    "SecurityGroup":{
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
         "GroupDescription" : "{{ EnvironmentName }}SecurityGroup",
         "VpcId" : {"Ref" : "VPC"},
         {#####  When No Egress Rules are Specified Default Allows All #####}
         "SecurityGroupIngress" : [
            {
              "IpProtocol" : "-1",
               "CidrIp" : { "Fn::GetAtt": ["VPC","CidrBlock"]}
            },
            {
              "IpProtocol" : "tcp",
               "FromPort" : "22",
               "ToPort" : "22",
               "CidrIp" : "0.0.0.0/0"
            },
            {
              "IpProtocol" : "tcp",
               "FromPort" : "10000",
               "ToPort" : "19999",
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
    {% if not Server.Public %}
    "{{ Server.Name }}ELB" : {
      "Type": "AWS::ElasticLoadBalancing::LoadBalancer",
      "Properties": {
        "Subnets" : [ { "Ref" : "Subnet{{ Server.AZ }}" }],
         "Instances" : [ { "Ref" : "{{ Server.Name }}" } ],
         "LoadBalancerName" : "{{ EnvironmentName}}{{ Server.Name }}ELB",
         "Listeners" : [
             {
               "InstancePort" : "10000",
               "InstanceProtocol" : "TCP",
               "LoadBalancerPort" : "10000",
               "Protocol" : "TCP"
             }
          ],
         "Scheme" : "internet-facing",
         "SecurityGroups" : [ { "Ref" : "SecurityGroup"} ],
         "Tags" : [
            {
              "Key": "Name",
              "Value" : "{{ EnvironmentName }}Server{{ Server.Name }}ELB"
            },
            {
              "Key": "Environment",
              "Value" : "{{ EnvironmentName }}"
            }
          ]
      },
      "DependsOn": ["VPCGatewayAttachment"]
    },
    {% endif %}
    "{{ Server.Name }}" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
         "AvailabilityZone" : "{{ RegionName }}{{ Server.AZ | lower }}",
         {% if Server.InstanceType.startswith('m4') %}
         "EbsOptimized" : true,
         {% else%}
         "EbsOptimized" : false,
         {% endif %}
         "ImageId" : "{{ Server.ImageId }}",
         "InstanceInitiatedShutdownBehavior" : "stop",
         "InstanceType" : "{{ Server.InstanceType }}",
         "KeyName" : "{{ KeyPair }}",
         "PrivateIpAddress" : "{{ Server.PrivateIP }}",
         "SecurityGroupIds" : [ { "Ref" : "SecurityGroup"}],
         {% if Server.Public %}
         "SubnetId" : { "Ref" : "PublicSubnet{{ Server.AZ }}" },
         {% else %}
         "SubnetId" : { "Ref" : "Subnet{{ Server.AZ }}" },
         {% endif %}
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
