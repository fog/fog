SINGLE_NODE_FORMAT = {'address' => String, 'id' => Integer, 'status' => String, 'weight' => Fog::Nullable::Integer, 'port' => Integer, 'condition' => String}
NODE_FORMAT = {'node' => SINGLE_NODE_FORMAT}
NODES_FORMAT = {'nodes' => [SINGLE_NODE_FORMAT]}
VIRTUAL_IP_FORMAT = {'type' => String, 'id' => Integer, 'type' => String, 'ipVersion' => String, 'address' => String}
VIRTUAL_IPS_FORMAT = { 'virtualIps' => [VIRTUAL_IP_FORMAT] }
LOAD_BALANCER_USAGE_FORMAT = {
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
      'sourceAddresses' => {
        'ipv4Servicenet'  => String,
        'ipv4Public'      => String,
        'ipv6Public'      => String,
      },
      'status' => String,
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
    'sourceAddresses' => {
      'ipv4Servicenet'  => String,
      'ipv4Public'      => String,
      'ipv6Public'      => String,
    },
    'status' => String,
    'cluster' => { 'name' => String },
    'virtualIps' => [VIRTUAL_IP_FORMAT],
    'nodes' => [SINGLE_NODE_FORMAT],
    'created' => { 'time' => String },
    'updated' => { 'time' => String },
  }.merge(CONNECTION_LOGGING_FORMAT)
}


