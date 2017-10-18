# Overview #
This project contains everything needed to set up a gemfire cluster and
a load test on AWS.

# Setup #
* The local machine requires python(2) to be installed and the following python
packages
 * jina2
 * boto3
 * awscli

* You will need to register a key pair with AWS and you will need the
corresponding .pem file on your local machine.
* You will need an AWS AccessKeyId and SecretAccessKey. You can either use your
master key (which is discouraged by Amazon) or create an IAM user.  The IAM
user you create will need to attach a user policy that grants access to all EC2, Cloud Formation and Elastic Load Balancing operations.  The following
policy definition can be used.

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "ec2:*",
                    "cloudformation:*",
                    "elasticloadbalancing:*"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
    }
    ```

__For detailed AWS setup instructions, see "AWS_Setup.docx"__

# Provision and Start the Cluster  #
Have a look at _config/awscluster.json_ to understand what is being deployed.

Generate the cluster definition.

```
python generateAWSCluster.py
```

This reads _config/awscluster.json_ and generates a more detailed deployment
plan: _config/env.json_

Now deploy the resources to AWS:

```
python aws_provision_storage.py   # provisions all the EBS stores
python aws_provision.py           # provisions network and compute resources
python setup.py                   # installs and configures software
```

# On Setting Up Grinder #

## grinder workers ##
in the /home/ec2-user/test folder

grinder.properties

```
grinder.consoleHost=192.168.1.106
grinder.consolePort=6372
grinder.jvm=/runtime/java/bin/java
```

grinder.sh

```
#!/bin/bash
export CLASSPATH='/runtime/gemfire/lib/*:/runtime/grinder/lib/grinder.jar:'
/runtime/java/bin/java  net.grinder.Grinder
```
Note that the console must be running before starting the workers.
__Also, note that gemfire needs to be first on the class path!__

## grinder console ##

grinderconsole.sh

```
#!/bin/bash

export CLASSPATH=~/Downloads/grinder-3.11/lib/grinder.jar
java net.grinder.Console
```

grinder.properties

```
grinder.processes=1
grinder.threads=4
grinder.runs=0
```

## To Run Grinder Locally Using a Reverse Tunnel ##

On the remote host:

```
sudo vi /etc/ssh/sshd_config   #enable GatewayPorts
sudo service sshd restart
```

On the desktop:

```
ssh -i ~/Downloads/yak-keypair.pem -R 192.168.1.106:6372:localhost:6372 ec2-user@13.58.63.76
```
