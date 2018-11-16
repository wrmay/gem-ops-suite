#!/usr/bin/python
import json
import os
import os.path
import shutil

if __name__ == '__main__':
    for i in range(1,100):
        dirname = 'tests/run_{:02d}'.format(i)
        if not os.path.exists(dirname):
            break

        if i == 99:
            raise Exception('no more test slots available')

    os.makedirs(dirname)

    with open('cluster.json','r') as f:
        cluster = json.load(f)

    for hostname in cluster['hosts']:
        host = cluster['hosts'][hostname]
        for process_name in host['processes']:
            process = host['processes'][process_name]
            if process['type'] == 'datanode':
                statsfile = '{}.gfs'.format(process_name)
                shutil.copy(statsfile,dirname)
                print 'copied {} to {}'.format(statsfile,dirname)
                logfile = '{}.log'.format(process_name)
                shutil.copy(logfile,dirname)
                print 'copied {} to {}'.format(logfile,dirname)

    for src in ['../load-generator/src/main/java/io/pivotal/pde/sample/LoadPeople.java', 'cluster.json', 'run_load_test.yml', 'install_gemfire_cluster.yml']:
        shutil.copy(src,dirname)
        print 'copied {} to {}'.format(src,dirname)
