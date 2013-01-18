module Fog
  module Compute
    class Cloudstack
      class Address < Fog::Model
        identity  :id,            :aliases => 'id'
        attribute :network_id,    :aliases => 'networkid'
        attribute :ip_address,    :aliases => 'ipaddress'
        attribute :traffic_type,  :aliases => 'traffictype'
        attribute :is_default,    :aliases => 'isdefault'
        attribute :mac_address,   :aliases => 'macaddress'
        attribute :netmask
        attribute :gateway
        attribute :type
      end
    end
  end
end
