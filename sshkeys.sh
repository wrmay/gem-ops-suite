ssh-keyscan -H 192.168.1.101 > /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.1.102 >> /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.1.103 >> /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.1.111 >> /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.2.101 >> /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.2.102 >> /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.2.103 >> /home/ec2-user/.ssh/known_hosts
ssh-keyscan -H 192.168.2.111 >> /home/ec2-user/.ssh/known_hosts
