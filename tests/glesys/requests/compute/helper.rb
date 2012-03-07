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
            'platform' => String
          }],
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
          }
        }

        DETAILS = {
          'debug' => {
            'input' =>  {
              'serverid'  =>  Fog::Nullable::String
            }
          },
          'server' => {
            'managedhosting'  => String,
            'cost'            => {
              'amount'      =>  Float,
              'timeperiod'  => String,
              'currency'    => String
            },
            'serverid'      => String,
            'datacenter'    => String,
            'memorysize'    => Integer,
            'cpucores'      => Integer,
            'transfer'      => Integer,
            'templatename'  => String,
            'iplist'        =>  [{
              'cost'      => Integer,
              'version'   => Fog::Nullable::Integer,
              'ipaddress' => Fog::Nullable::String,
              'currency'  => String
            }], 
            'description' => String,
            'hostname'    => String,
            'disksize'    => Integer,
            'platform'    => String,
            'state'       => Fog::Nullable::String
          },
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
          }
        }

        STOP = DETAILS.merge(
          'debug' => {
            'input' =>  {
              'serverid'  => Fog::Nullable::String,
              'type'      => String
            }
          }
        )

        CREATE = DETAILS.merge(
          'debug' => {
            'input' =>  {
              'serverid'      => Fog::Nullable::String,
              'hostname'      => String,
              'rootpassword'  => String,
              'datacenter'    => String,
              'platform'      => String,
              'templatename'  => String,
              'disksize'      => String,
              'memorysize'    => String,
              'cpucores'      => String,
              'transfer'      => String,
              'description'   => String
            }
          }
        )

        STATUS = {
          'debug' => {
            'input' => {
              'serverid' => String
            }
          },
          'server' => {
            'memory'    => {
              'usage' => Fog::Nullable::Integer,
              'max'   => Fog::Nullable::Integer,
              'unit'  => Fog::Nullable::String
            },
            'transfer'  => {
              'usage' => Fog::Nullable::Integer,
              'max'   => Fog::Nullable::Integer,
              'unit'  => Fog::Nullable::String
            },
            'disk'      => {
              'usage' => Fog::Nullable::Integer,
              'max'   => Fog::Nullable::Integer,
              'unit'  => Fog::Nullable::String
            },
            'state'     => String,
            'transfer'  => {
              'usage' => Fog::Nullable::Integer,
              'max'   => Fog::Nullable::Integer,
              'unit'  => Fog::Nullable::String
            },
            'cpu'       => [],
            'uptime'    => {
              'current' => Fog::Nullable::Integer,
              'unit'    => String
            }
          },
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
          }
       }

        DESTROY = {
          'debug' => {
            'input' => {
              'serverid' => String,
              'keepip'   => String
            }
          },
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
          }
        }

      end
      module Ips

        IPLIST = {
          'debug' => {
            'input' => []
          },
          'iplist' => [{
            'cost' => {
              'amount'      => Integer,
              'timeperiod'  => String,
              'currency'    => String
            },
            'netmask'     => Fog::Nullable::String,
            'broadcast'   => Fog::Nullable::String,
            'gateway'     => Fog::Nullable::String,
            'nameservers' => [],
            'datacenter'  => String,
            'serverid'    => Fog::Nullable::String,
            'platform'    => String,
            'ipaddress'   => String,
            'ipversion'   => Integer,
            'ptr'         => String,
            'reserved'    => String
          }],
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
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
          'iplist' => {
            'ipversion'   => Integer,
            'datacenter'  => String,
            'platform'    => String,
            "ipaddresses" => []
          },
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
          },
        }

        IPLIST_CATCH_RELEASE = {
          'debug' => {
            'input' => {
              'ipaddress' => String,
            }
          },
          'details' => {
            'cost' => {
              'amount'      => Integer,
              'timeperiod'  => String,
              'currency'    => String
            },
            'ipaddress'   => String,
            'netmask'     => String,
            'broadcast'   => String,
            'gateway'     => String,
            'nameservers' => [],
            'datacenter'  => String,
            'serverid'    => Fog::Nullable::String,
            'platform'    => String,
            'ipaddress'   => String,
            'ipversion'   => Integer,
            'ptr'         => String,
            'reserved'    => String
          },
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
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
              'name'              => String,
              'operatingsystem'   => String,
              'minimummemorysize' => Integer,
              'minimumdisksize'   => Integer,
              'platform'          => String
            }],
            'OpenVZ' => [{
              'name'              => String,
              'operatingsystem'   => String,
              'minimummemorysize' => Integer,
              'minimumdisksize'   => Integer,
              'platform'          => String
            }]
          },
          'status' => {
            'timestamp' => String,
            'code'      => Integer,
            'text'      => String
          }
        }

      end
    end
  end
end
