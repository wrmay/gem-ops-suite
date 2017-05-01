import subprocess

ssh_options = ['-o', 'StrictHostKeyChecking=false', '-o','UserKnownHostsFile=/dev/null', '-i', './vagrant/id_rsa']

if __name__ == '__main__':
  for server in ['10.10.10.101','10.10.10.102']:
     for script in ['gf.py','cluster.py','clusterdef.py','gemprops.py', 'cluster.json', 'gemfire-toolkit/target/gemfire-toolkit-N-runtime.tar.gz']:
        subprocess.check_call(['scp'] + ssh_options + [script, 'vagrant@{0}:/home/vagrant/gemfire_cluster'.format(server)])

     subprocess.check_call(['ssh'] + ssh_options + ['vagrant@{0}'.format(server),'tar', '-C', '/home/vagrant/gemfire_cluster','-xzf', '/home/vagrant/gemfire_cluster/gemfire-toolkit-N-runtime.tar.gz'])
