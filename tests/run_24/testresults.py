Removed p2p.backlog from cluster configuration

Got tired of wating for it to finish


[ec2-user@ip-192-168-1-101 ~]$ nstat -z | grep Listen
TcpExtListenOverflows           34019              0.0
TcpExtListenDrops               34019              0.0

[ec2-user@ip-192-168-1-102 ~]$ nstat -z | grep Listen
TcpExtListenOverflows           37889              0.0
TcpExtListenDrops               37889              0.0


