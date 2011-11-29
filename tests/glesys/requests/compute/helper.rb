class Glesys
  module Compute
    module Formats
      module Servers

        LIST = {
          'debug' => {
            'input' => []
          },
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
          'debug' => {
            'input' => {
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
            }
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
          'debug' => {
            'input' => {
              'serverid' => String,
              'keepip'   => String,
            }
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

        DETAILS = {
          'debug' => {
            'input' =>  {
              'serverid'  =>  String
            }
          },
          'server' => {
            'managedhosting'  => String,
            'cost'            => {
              'amount'      =>  Float,
              'timeperiod'  => String,
              'currency'    => String
            }, 
            'serverid'    => String,
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
          'debug' => {
            'input' => {
              'serverid' => String
            }
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
          'debug' => {
            'input' => {
              'serverid' => String
            }
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

        STOP = {
          'debug' => {
            'input' => {
              'serverid'  => String,
              'type'      => String
            }
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

      end
      module Ips

        IPLIST = {
          'debug' => {
            'input' => []
          },
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
          'debug' => {
            'input' => {
              'datacenter'  => String,
              'ipversion'   => String,
              'platform'    => String
            }
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
          'debug' => {
            'input' => {
              'ipaddress' => String,
            }
          },
          'status' => {
            'code' => String,
            'text' => String
          }
        }

      end
      module Templates

        LIST = {
          'debug' => {
            'input' => []
          },
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
