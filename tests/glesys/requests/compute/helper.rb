class Glesys
  module Compute
    module Formats
      module Servers

        LIST = {
          'arguments' => [],
          'servers' => [{
            'serverid' => String,
            'hostname' => String,
            'datacenter' => String,
            'platform' => String,
          }],
          'status' => {
            'code' => String,
            'text' => String
          }
        }

        CREATE = {
          'arguments' => {
            "rootpw"        => String, 
            "disksize"      => String, 
            "memorysize"    => String, 
            "datacenter"    => String, 
            "cpucores"      => String,
            "transfer"      => String,
            "template"      => String,
            "description"   => String,
            "hostname"      => String,
            "platform"      => String
          },
          'server' => {
            'serverid' => String,
            'hostname' => String,
            'iplist' => [{
              'cost' => String,
              'version' => String,
              'ip' => String
            }]
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

        DESTROY = {
          'arguments' => {
            'serverid' => String,
            'keepip'   => String,
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

        DETAILS = {
          'arguments' =>  {
            'serverid'  =>  String
          }, 
          'server' => {
            'managedhosting'  => String,
            'cost'            => {
              'amount'      =>  Float,
              'timeperiod'  => String, 
              'currency'    => String
            }, 
            'datacenter'  => String, 
            'memory'      => String,
            'cpucores'    => String, 
            'transfer'    => String, 
            'template'    => String, 
            'iplist'      =>  [{
              'cost'    => String, 
              'version' => String, 
              'ip'      => String
            }], 
            'description' => String,
            'hostname'    => String, 
            'disk'        => String, 
            'platform'    => String
          }, 
          'status' => {
            'code' => String, 
            'text' => String
          }
        }

        STATUS = {
          'arguments' => {
            'serverid' => String
          }, 
          'server' => {
            'memory'    => String, 
            'bandwidth' => {
              'last30days'  => Integer, 
              'today'       => Integer,
              'max'         => String
            }, 
            'cpu'     => String, 
            'disk'    => String, 
            'state'   => String
          }, 
          'status' => { 
            'code' => String,
            'text' => String
          }
       }
        
        START = {
          'arguments' => {
            'serverid' => String
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

        STOP = {
          'arguments' => {
            'serverid'  => String,
            'type'      => String
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

      end
      module Ips
    
        IPLIST = {
          'arguments' => [],
          'iplist' => [{
            'price' => {
              'amount' => String,
              'timeperiod' => String,
              'currency' => String
            },
            'datacenter' => String,
            'serverid' => Fog::Nullable::String,
            'platform' => String,
            'ip'       => String,
            'version'  => String,
            'PTR'      => String,
          }],
          'status' => {
            'code' => String,
            'text' => String
          }
        }
    
        IPLIST_ALL = {
          'arguments' => {
            'datacenter'  => String,
            'ipversion'   => String,
            'platform'    => String
          },
          'iplist' => [],
          'status' => {
            'code' => String,
            'text' => String
          },
          'ipinfo' => {
            'datacenter' => String,
            'ipversion'  => Integer,
            'platform'   => String
          }
        }

        IPLIST_CATCH_RELEASE = {
          'arguments' => {
            'ipaddress' => String, 
          }, 
          'status' => {
            'code' => String, 
            'text' => String
          }
        }

      end
      module Templates

        LIST = {
          'arguments' => [],
          'templates' =>  { 
            'Xen' => [{
              'name'          => String,
              'os'            => String, 
              'min_mem_size'  => String, 
              'min_disk_size' => String, 
              'platform'      => String
            }],
            'OpenVZ' => [{
              'name'          => String,
              'os'            => String, 
              'min_mem_size'  => String, 
              'min_disk_size' => String, 
              'platform'      => String
            }]
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

      end
    end
  end
end
