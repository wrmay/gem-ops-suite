#
# Copyright (c) 2015-2016 Pivotal Software, Inc. All Rights Reserved.
#


HANDLED_PROPS=['gemfire','java-home','cluster-home', 'bind-address', 'port',
               'jvm-options','server-bind-address', 'server-port', 'classpath'
               , 'hostname-for-clients']


GEMFIRE_PROPS=[
    'ack-severe-alert-threshold'
    ,'ack-wait-threshold'
    ,'archive-disk-space-limit'
    ,'archive-file-size-limit'
    ,'async-distribution-timeout'
    ,'async-max-queue-size'
    ,'async-queue-timeout'
#   ,'bind-address' handled by a gfsh --bind-address arg instead of a --J-D
    ,'cache-xml-file'
    ,'cluster-configuration-dir'
    ,'cluster-ssl-ciphers'
    ,'cluster-ssl-enabled'
    ,'cluster-ssl-keystore'
    ,'cluster-ssl-keystore-password'
    ,'cluster-ssl-keystore-type'
    ,'cluster-ssl-protocols'
    ,'cluster-ssl-require-authentication'
    ,'cluster-ssl-truststore'
    ,'cluster-ssl-truststore-password'
    ,'conflate-events'
    ,'conserve-sockets'
    ,'delta-propagation'
    ,'deploy-working-dir'
    ,'disable-auto-reconnect'
    ,'disable-tcp'
    ,'distributed-system-id'
    ,'durable-client-id'
    ,'durable-client-timeout'
    ,'enable-cluster-configuration'
    ,'enable-network-partition-detection'
    ,'enable-time-statistics'
    ,'enforce-unique-host'
    ,'gateway-ssl-ciphers'
    ,'gateway-ssl-enabled'
    ,'gateway-ssl-keystore'
    ,'gateway-ssl-keystore-password'
    ,'gateway-ssl-keystore-type'
    ,'gateway-ssl-protocols'
    ,'gateway-ssl-require-authentication'
    ,'gateway-ssl-truststore'
    ,'gateway-ssl-truststore-password'
    ,'groups'
    ,'http-service-bind-address'
    ,'http-service-port'
    ,'http-service-ssl-ciphers'
    ,'http-service-ssl-enabled'
    ,'http-service-ssl-keystore'
    ,'http-service-ssl-keystore-password'
    ,'http-service-ssl-keystore-type'
    ,'http-service-ssl-protocols'
    ,'http-service-ssl-require-authentication'
    ,'http-service-ssl-truststore'
    ,'http-service-ssl-truststore-password'
    ,'jmx-manager'
    ,'jmx-manager-access-file'
    ,'jmx-manager-bind-address'
    ,'jmx-manager-hostname-for-clients'
    ,'jmx-manager-http-port'
    ,'jmx-manager-password-file'
    ,'jmx-manager-port'
    ,'jmx-manager-ssl'
    ,'jmx-manager-ssl-ciphers'
    ,'jmx-manager-ssl-enabled'
    ,'jmx-manager-ssl-keystore'
    ,'jmx-manager-ssl-keystore-password'
    ,'jmx-manager-ssl-keystore-type'
    ,'jmx-manager-ssl-protocols'
    ,'jmx-manager-ssl-require-authentication'
    ,'jmx-manager-ssl-truststore'
    ,'jmx-manager-ssl-truststore-password'
    ,'jmx-manager-start'
    ,'jmx-manager-update-rate'
    ,'license-application-cache'
    ,'license-data-management'
    ,'license-server-timeout'
    ,'license-working-dir'
    ,'load-cluster-configuration-from-dir'
    ,'locators'
    ,'locator-wait-time'
    ,'log-disk-space-limit'
    ,'log-file'
    ,'log-file-size-limit'
    ,'log-level'
    ,'max-num-reconnect-tries'
    ,'max-wait-time-reconnect'
    ,'mcast-address'
    ,'mcast-flow-control'
    ,'mcast-port'
    ,'mcast-recv-buffer-size'
    ,'mcast-send-buffer-size'
    ,'mcast-ttl'
    ,'member-timeout'
    ,'membership-port-range'
    ,'memcached-bind-address'
    ,'memcached-port'
    ,'memcached-protocol'
#   ,'name' cannot be set using a property - it is set via the key in the host.processes dictionary
    ,'redundancy-zone'
    ,'remote-locators'
    ,'remove-unresponsive-client'
    ,'roles'
    ,'security-client-accessor'
    ,'security-client-accessor-pp'
    ,'security-client-auth-init'
    ,'security-client-authenticator'
    ,'security-client-dhalgo'
    ,'security-log-file'
    ,'security-log-level'
    ,'security-peer-auth-init'
    ,'security-peer-authenticator'
    ,'security-peer-verifymember-timeout'
#   ,'server-bind-address'  this is set using a gfsh --server-bind-address argument not a --J-D argument
    ,'server-ssl-ciphers'
    ,'server-ssl-enabled'
    ,'server-ssl-keystore'
    ,'server-ssl-keystore-password'
    ,'server-ssl-keystore-type'
    ,'server-ssl-protocols'
    ,'server-ssl-require-authentication'
    ,'server-ssl-truststore'
    ,'server-ssl-truststore-password'
    ,'socket-buffer-size'
    ,'socket-lease-time'
    ,'ssl-ciphers'
    ,'ssl-enabled'
    ,'ssl-protocols'
    ,'ssl-require-authentication'
    ,'start-dev-rest-api'
    ,'start-locator'
    ,'statistic-archive-file'
    ,'statistic-sample-rate'
    ,'statistic-sampling-enabled'
    ,'tcp-port'
    ,'tombstone-gc-threshold'
    ,'udp-fragment-size'
    ,'udp-recv-buffer-size'
    ,'udp-send-buffer-size'
    ,'use-cluster-configuration'
    ,'user-command-packages'
    ,'writable-working-dir'
    ]
