require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class PIF < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=PIF
        
        identity :reference
        
        attribute :uuid
        attribute :physical
        attribute :mac,                     :aliases => :MAC
        attribute :currently_attached
        attribute :device
        attribute :device_name
        attribute :metrics
        attribute :dns,                     :aliases => :DNS
        attribute :gateway
        attribute :ip,                      :aliases => :IP
        attribute :ip_configuration_mode    
        attribute :mtu,                     :aliases => :MTU
        attribute :__network,               :aliases => :network
        attribute :netmask
        attribute :status_code
        attribute :status_detail
        attribute :management
        attribute :vlan,                    :aliases => :VLAN
        attribute :other_config
        attribute :__host,                  :aliases => :host
        
        def network
          connection.networks.get __network
        end

        def host
          connection.hosts.get __host
        end
      
      end
      
    end
  end
end
