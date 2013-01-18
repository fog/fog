require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class HostMetrics < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=VM_host_metrics
        
        identity :reference
        
        attribute :uuid
        attribute :live
        attribute :memory_free
        attribute :memory_total
        attribute :other_config
        attribute :last_updated
        
        def initialize(attributes = {})
          super
          self.last_updated = attributes[:last_updated].to_time
        end
        
      end
      
    end
  end
end
