SINGLE_NODE_FORMAT = {'address' => String, 'id' => Integer, 'status' => String, 'weight' => Fog::Nullable::Integer, 'port' => Integer, 'condition' => String}
NODE_FORMAT = {'node' => SINGLE_NODE_FORMAT}
NODES_FORMAT = {'nodes' => [SINGLE_NODE_FORMAT]}
VIRTUAL_IP_FORMAT = {'type' => String, 'id' => Integer, 'type' => String, 'ipVersion' => String, 'address' => String}
VIRTUAL_IPS_FORMAT = { 'virtualIps' => [VIRTUAL_IP_FORMAT] }

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
    'status' => String,
    'cluster' => { 'name' => String },
    'virtualIps' => [VIRTUAL_IP_FORMAT],
    'nodes' => [SINGLE_NODE_FORMAT],
    'created' => { 'time' => String },
    'updated' => { 'time' => String },
    'connectionLogging' => { 'enabled' => Fog::Boolean }
}}


