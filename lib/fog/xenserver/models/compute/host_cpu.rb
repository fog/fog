require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      #
      # A physical CPU
      #
      # @see http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=host_cpu
      #
      class HostCpu < Fog::Model
        
        identity :reference
        
        attribute :uuid
        attribute :family
        attribute :features
        attribute :flags
        attribute :__host,          :aliases => :host
        attribute :model
        attribute :model_name,      :aliases => :modelname
        attribute :number
        attribute :other_config
        attribute :speed
        attribute :stepping
        attribute :utilisation
        attribute :vendor

        def host
          service.hosts.get __host
        end
        
      end
      
    end
  end
end
