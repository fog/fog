SINGLE_NODE_FORMAT = {'address' => String, 'id' => Integer, 'status' => String, 'weight' => Fog::Nullable::Integer, 'port' => Integer, 'condition' => String, 'type' => String}
NODE_FORMAT = {'node' => SINGLE_NODE_FORMAT.merge({ 'metadata' => []})}
NODES_FORMAT = {'nodes' => [SINGLE_NODE_FORMAT]}
VIRTUAL_IP_FORMAT = {'type' => String, 'id' => Integer, 'type' => String, 'ipVersion' => String, 'address' => String}
VIRTUAL_IPS_FORMAT = { 'virtualIps' => [VIRTUAL_IP_FORMAT] }
SOURCE_ADDRESSES = {
  'ipv4Servicenet'  => String,
  'ipv4Public'      => String,
  'ipv6Public'      => String,
}
LOAD_BALANCER_USAGE_FORMAT = {
  'links' => [
    {
      'otherAttributes' => [],
      'href' => Fog::Nullable::String,
      'rel' => Fog::Nullable::String
    }
  ],
  'loadBalancerUsageRecords' => [
    {
      'id' => Fog::Nullable::Integer,
      'eventType' => Fog::Nullable::String,
      'averageNumConnections' => Fog::Nullable::Float,
      'incomingTransfer' => Fog::Nullable::Integer,
      'outgoingTransfer' => Fog::Nullable::Integer,
      'numVips' => Fog::Nullable::Integer,
      'numPolls' => Fog::Nullable::Integer,
      'startTime' => Fog::Nullable::String,
      'endTime' => Fog::Nullable::String,
      'vipType' => Fog::Nullable::String,
    }
  ]
}

LOAD_BALANCER_STATS_FORMAT = {
    'connectTimeOut' => Integer,
    'connectError' => Integer,
    'connectFailure' => Integer,
    'dataTimedOut' => Integer,
    'keepAliveTimedOut' => Integer,
    'maxConn' => Integer
}

SSL_TERMINATION_FORMAT = {
  'sslTermination' => {
    'certificate' => String,
    'privatekey' => String,
    'enabled' => Fog::Boolean,
    'securePort' => Integer,
    'secureTrafficOnly' => Fog::Boolean,
    'intermediateCertificate' => Fog::Nullable::String
  }
}

USAGE_FORMAT = {
  'accountId' => Integer,
  'loadBalancerUsages' => [
    {
      'loadBalancerId' => Fog::Nullable::Integer,
      'loadBalancerName' => Fog::Nullable::String
    }.merge(LOAD_BALANCER_USAGE_FORMAT)
  ],
  'accountUsage' => [
    {
      'startTime' => Fog::Nullable::String,
      'numLoadBalancers' => Fog::Nullable::Integer,
      'numPublicVips' => Fog::Nullable::Integer,
      'numServicenetVips' => Fog::Nullable::Integer
    }
  ]
}
CONNECTION_LOGGING_FORMAT = {
  'connectionLogging' => {
    'enabled' => Fog::Boolean
  }
}
CONNECTION_THROTTLING_FORMAT = {
  'connectionThrottle' => {
    'maxConnections' => Fog::Nullable::Integer,
    'minConnections' => Fog::Nullable::Integer,
    'maxConnectionRate' => Fog::Nullable::Integer,
    'rateInterval' => Fog::Nullable::Integer
  }
}
SESSION_PERSISTENCE_FORMAT = {
  'sessionPersistence' => {
    'persistenceType' => Fog::Nullable::String
  }
}
CONTENT_CACHING_FORMAT = {
  'contentCaching' => {
    'enabled' => Fog::Boolean
  }
}
ACCESS_LIST_FORMAT = {
  'accessList' => [
    {
      'address' => String,
      'id' => Integer,
      'type' => String
    }
  ]
}
HEALTH_MONITOR_FORMAT = {
  'healthMonitor' => {
    'type' => Fog::Nullable::String,
    'delay' => Fog::Nullable::Integer,
    'timeout' => Fog::Nullable::Integer,
    'attemptsBeforeDeactivation' => Fog::Nullable::Integer,
    'path' => Fog::Nullable::String,
    'bodyRegex' => Fog::Nullable::String,
    'statusRegex' => Fog::Nullable::String
  }
}

STATUS_ACTIVE = 'ACTIVE'

LOAD_BALANCERS_FORMAT = {
  'loadBalancers' => [
    {
      'name' => String,
      'id' => Integer,
      'port' => Integer,
      'protocol' => String,
      'algorithm' => String,
      'status' => String,
      'virtualIps' => [VIRTUAL_IP_FORMAT],
      'created' => { 'time' => String },
      'updated' => { 'time' => String },
      'nodeCount' => Integer
    }]
}

LOAD_BALANCERS_DETAIL_FORMAT = {
  'loadBalancers' => [
    {
      'name' => String,
      'id' => Integer,
      'port' => Integer,
      'protocol' => String,
      'algorithm' => String,
      'sourceAddresses' => SOURCE_ADDRESSES,
      'status' => String,
      'timeout' => Integer,
      'virtualIps' => [VIRTUAL_IP_FORMAT],
      'nodes' => [SINGLE_NODE_FORMAT],
      'created' => { 'time' => String },
      'updated' => { 'time' => String }
    }]
}
LOAD_BALANCER_FORMAT = {
  'loadBalancer' => {
    'name' => String,
    'id' => Integer,
    'port' => Integer,
    'protocol' => String,
    'algorithm' => String,
    'sourceAddresses' => SOURCE_ADDRESSES,
    'status' => String,
    'timeout' => Integer,
    'cluster' => { 'name' => String },
    'virtualIps' => [VIRTUAL_IP_FORMAT],
    'nodes' => Fog::Nullable::Array,
    'created' => { 'time' => String },
    'updated' => { 'time' => String },
    'contentCaching' => { 'enabled' => Fog::Boolean }
  }.merge(CONNECTION_LOGGING_FORMAT)
}

ERROR_PAGE_FORMAT = {
  'errorpage' => {
    'content' => String
  }
}

PRIVATE_KEY = '-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAqSXePu8qLmniU7jNxoWq3SLkR8txMsl1gFYftpq7NIFaGfzV
f4ZswYdEYDVWWRepQjS0TvsB0d5+usEUy/pcdZAlQLnn+540iLkvxKPVMzojUbG6
yOAmjC/xAZuExJHtfCrRHUQ4WQCwqyqANfP81y1inAb0zJGbtWUreV+nv8Ue77qX
77fOuqI6zOHinGZU7l25XGLcVUphgt8UtHZBzz2ahoftZ97DhUyQiSJQCaHXJd3Q
eIHAq9qc7hu+usiYZWz34A0lw/gAl+RYcdvVc8kIwWxpiSieqqBPOwNzN5B0+9uu
5sDzMGMFnnSWcNKIPumX0rke3xFUl3UD6GJwvwIDAQABAoIBABQ7alT+yH3avm6j
OUHYtTJUPRf1VqnrfPmH061E3sWN/1gCbQse6h1P77bOSnDHqsA3i6Wy0mnnAiOW
esVXQf3x6vLOCdiH+OKtu+/6ZMMG3jikWKI0ZYf5KAu4LW5RwiVK/c5RXagPtBIV
OFa7w299h0EAeAGMHSLaYhPXhDokyJa6yDkAQL3n+9L3V8kNWeCELfrqXnXF4X0K
CJp622tS/fW6kzppJyLJ4GPkK9HNMpu02/n2Z7swWypfF+7set+9/aNTooDYWzCu
dbnRgqEIG1IP8+t6HG6x9VujJVJLIW/WLITnQ/WTRXOQHBGhazgmwe1GPdxsQgXu
/wIcsIkCgYEA8Si0q+QhmJyoAm8vTHjo6+DD06YYTvSODLJOpOqr1ncGGDJ/evBw
x+9QsK3veXMbAK5G7Xss32IuXbBfjqQ89+/q/YT4BnS3T0OQa2WlR8tURNphCDr5
B3yD212kJTTehC+p7BI9zhnWXD9kImh4vm4XcOsC9iqOSCZkGfvRPRsCgYEAs46t
Y85v2Pk235r1BPbgKwqYR+jElH4VWKu+EguUeQ4BlS47KktlLhvHtwrTv/UZ+lPx
8gSJTgyy7iEmzcGwPf1/MI5xg+DPgGhbr2G8EvrThmdHy+rPF2YSp1iBmJ4xq/1r
6XYKvf6ST3iujxTPU5xPEDUSLsH2ejJD/ddqSS0CgYEAkIdxyDa//8ObWWIjObSY
+4zIMBcyKFeernNKeMH/3FeW+neBOT/Sh7CgblK/28ylWUIZVghlOzePTC0BB+7c
b0eFUQ0YzF204rc+XW8coCt2xJEQaCtXxinUqGq1jmriFNyv/MBt9BA+DSkcrRZp
js9SEyV1r+yPOyRvB7eIjhMCgYEAkd5yG+fkU1c6bfNb4/mPaUgFKD4AHUZEnzF+
  ivhfWOy4+nGBXT285/VnjNs95O8AeK3jmyJ2TTLh1bSW6obUX7flsRO3QlTLHd0p
xtPWT3D3kHOtDwslzDN/KfYr6klxvvB0z0e3OFxsjiVTYiecuqb8UAVdTSED1Ier
Vre+v80CgYB86OqcAlR3diNaIwHgwK5kP2NAH1DaSwZXoobYpdkjsUQfJN5jwJbD
4/6HVydoc5xe0z8B+O1VUzC+QA0gdXgHbmLZBIUeQU8sE4hGELoe/eWULXGwI91M
FyEWg03jZj8FkFh2954zwU6BOcbeL+9GrTdTPu1vuHoTitmNEye4iw==
  -----END RSA PRIVATE KEY-----'

CERTIFICATE = '-----BEGIN CERTIFICATE-----
MIIEWjCCA0KgAwIBAgIGATTTGu/tMA0GCSqGSIb3DQEBBQUAMHkxCzAJBgNVBAYT
AlVTMQ4wDAYDVQQIEwVUZXhhczEOMAwGA1UEBxMFVGV4YXMxGjAYBgNVBAoTEVJh
Y2tTcGFjZSBIb3N0aW5nMRQwEgYDVQQLEwtSYWNrRXhwIENBNTEYMBYGA1UEAxMP
Y2E1LnJhY2tleHAub3JnMB4XDTEyMDExMjE4MDgwNVoXDTM5MDUzMDE4MDgwNVow
gZcxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIEwVUZXhhczEUMBIGA1UEBxMLU2FuIEFu
dG9uaW8xEDAOBgNVBAoTB1JhY2tFeHAxEDAOBgNVBAsTB1JhY2tEZXYxPjA8BgNV
BAMMNW15c2l0ZS5jb20vZW1haWxBZGRyZXNzPXBoaWxsaXAudG9vaGlsbEByYWNr
c3BhY2UuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqSXePu8q
LmniU7jNxoWq3SLkR8txMsl1gFYftpq7NIFaGfzVf4ZswYdEYDVWWRepQjS0TvsB
0d5+usEUy/pcdZAlQLnn+540iLkvxKPVMzojUbG6yOAmjC/xAZuExJHtfCrRHUQ4
WQCwqyqANfP81y1inAb0zJGbtWUreV+nv8Ue77qX77fOuqI6zOHinGZU7l25XGLc
VUphgt8UtHZBzz2ahoftZ97DhUyQiSJQCaHXJd3QeIHAq9qc7hu+usiYZWz34A0l
w/gAl+RYcdvVc8kIwWxpiSieqqBPOwNzN5B0+9uu5sDzMGMFnnSWcNKIPumX0rke
3xFUl3UD6GJwvwIDAQABo4HIMIHFMIGjBgNVHSMEgZswgZiAFIkXQizRaftxVDaL
P/Fb/F2ht017oX2kezB5MQswCQYDVQQGEwJVUzEOMAwGA1UECBMFVGV4YXMxDjAM
BgNVBAcTBVRleGFzMRowGAYDVQQKExFSYWNrU3BhY2UgSG9zdGluZzEUMBIGA1UE
CxMLUmFja0V4cCBDQTQxGDAWBgNVBAMTD2NhNC5yYWNrZXhwLm9yZ4IBAjAdBgNV
HQ4EFgQUQUXHjce1JhjJDA4nhYcbebMrIGYwDQYJKoZIhvcNAQEFBQADggEBACLe
vxcDSx91uQoc1uancb+vfkaNpvfAxOkUtrdRSHGXxvUkf/EJpIyG/M0jt5CLmEpE
UedeCFlRN+Qnsqt589ZemWWJwth/Jbu0wQodfSo1cP0J2GFZDyTd5cWgm0IxD8A/
ZRGzNnTx3xskv6/lOh7so9ULppEbOsZTNqQ4ahbxbiaR2iDTQGF3XKSHha8O93RB
YlnFahKZ2j0CpYvg0lJjfN0Lvj7Sm6GBA74n2OrGuB14H27wklD+PtIEFniyxKbq
5TDO0l4yDgkR7PsckmZqK22GP9c3fQkmXodtpV1wRjcSAxxVWYm+S24XvMFERs3j
yXEf+VJ0H+voAvxgbAk=
-----END CERTIFICATE-----'
