import os.path
import shutil
import subprocess

if __name__ == '__main__':
   {% if Servers[ServerNum].Installations[InstallationNum].Owner %}
   owner = '{{ Servers[ServerNum].Installations[InstallationNum].Owner }}'
   {% else %}
   owner = ''
   {% endif %}
   cluster_home = '{{ Servers[ServerNum].Installations[InstallationNum].ClusterHome }}'

   mvnEnv = dict()
   mvnEnv['JAVA_HOME'] = '/runtime/java'

   if len(owner) > 0:
      subprocess.check_call(['sudo','-u',owner,'-E', '/runtime/maven/bin/mvn','-DskipTests','package'], cwd='/tmp/setup' , env=mvnEnv)
   else:
      subprocess.check_call(['/runtime/maven/bin/mvn','-DskipTests','package'], cwd='/tmp/setup' , env=mvnEnv)

   print 'built gemfire-dynamic-security'

   shutil.copy('/tmp/setup/target/gemfire-dynamic-security-1.0.3.jar', cluster_home)

   if len(owner) > 0:
      subprocess.check_call(['chown', '{0}:{0}'.format(owner), os.path.join(cluster_home, 'gemfire-dynamic-security-1.0.3.jar')])

   print 'installed gemfire-dynamic-security'
