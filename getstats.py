#!/usr/bin/python
import json
import subprocess

def scp_command(host,key,user,source,target):
    result = []
    result += ['scp','-o','StrictHostKeyChecking=no','-o','UserKnownHostsFile=/dev/null']
    result += ['-i',key]
    result += ['{}@{}:{}'.format(user,host,source),target]
    return result

def statsfile(nodename):
    return '/runtime/gem_cluster_1/{}/datanode.gfs'.format(nodename)

def logfile(nodename):
    return '/runtime/gem_cluster_1/{}/{}.log'.format(nodename, nodename)

if __name__ == '__main__':
    with open('cluster.json','r') as f:
        cluster = json.load(f)

    for hostname in cluster['hosts']:
        host = cluster['hosts'][hostname]
        ssh_host = host['ssh']['host']
        ssh_user = host['ssh']['user']
        ssh_key_file = host['ssh']['key-file']
        for process_name in host['processes']:
            process = host['processes'][process_name]
            if process['type'] == 'datanode':
                source = statsfile(process_name)
                target = '{}.gfs'.format(process_name)
                subprocess.check_call(scp_command(ssh_host,ssh_key_file,ssh_user,source,target))
                print 'copied {} from {} to {}.'.format(source,ssh_host, target)
                source = logfile(process_name)
                target = '{}.log'.format(process_name)
                subprocess.check_call(scp_command(ssh_host,ssh_key_file,ssh_user,source,target))
                print 'copied {} from {} to {}.'.format(source,ssh_host, target)
