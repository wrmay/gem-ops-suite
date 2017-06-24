import boto3
import json
import os.path
import tests.base

class ProvisionTest(tests.base.TestContext):

    def __init__(self):
        tests.base.TestContext.__init__(self)
        self.description = 'Provision test cluster on AWS'

    def setup(self):
        self.run(['python','generateAWSCluster.py'])
        self.run(['python','aws_provision_storage.py'])
        self.run(['python','aws_provision.py'])

    def teardown(self):
        self.run(['python','aws_destroy.py'])
        self.run(['python','aws_destroy_storage.py'])

    def verify(self):
        with open(os.path.join(self.homedir,'config','awscluster.json')) as f:
            config = json.load(f)

        server_names = []
        for server in config['Servers']:
            server_names.append(config['EnvironmentName'] + 'Server' + server['Name'])

        filters = []
        name_filter = dict()
        state_filter = dict()
        name_filter['Name'] = 'tag:Name'
        name_filter['Values'] = server_names
        state_filter['Name'] = 'instance-state-name'
        state_filter['Values'] = ['running']
        filters.append(name_filter)
        filters.append(state_filter)

        ec2 = boto3.client('ec2', region_name=config['RegionName'])
        result = ec2.describe_instances(Filters=filters)
        match_count = 0
        for reservation in result['Reservations']:
            for instance in reservation['Instances']:
                match_count += 1

        if match_count != 3:
            raise tests.base.TestError('Expected 3 running ec2 instances but found only {0}'.format(match_count) )
