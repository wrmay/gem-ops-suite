import json
import subprocess

ssh_options = ['-o', 'StrictHostKeyChecking=false', '-o','UserKnownHostsFile=/dev/null', '-q']

if __name__ == '__main__':

  with open('cluster.json','r') as f:
      cluster_config = json.load(f)

  cluster_home = cluster_config['global-properties']['cluster-home']
  for name, server in cluster_config['hosts'].items():
     host = server['ssh']['host']
     user = server['ssh']['user']
     key_file = server['ssh']['key-file']
     for script in ['gf.py','cluster.py','clusterdef.py','gemprops.py', 'cluster.json', 'gemfire-toolkit/target/gemfire-toolkit-N-runtime.tar.gz']:
        subprocess.check_call(['scp'] + ssh_options + ['-i',key_file,script, '{0}@{1}:{2}'.format(user,host,cluster_home)])

     print 'copied cluster scripts and cluster config to {0} on {1}'.format(cluster_home, host)

     subprocess.check_call(['ssh'] + ssh_options + ['-i',key_file,'{0}@{1}'.format(user,host),'tar', '-C', cluster_home ,'-xzf', '{0}/gemfire-toolkit-N-runtime.tar.gz'.format(cluster_home)])
     print 'copied gemfire toolkit to {0} on {1}'.format(cluster_home, host)
