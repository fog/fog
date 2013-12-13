require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class VbdMetrics < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=VBD_metrics
        
        identity :reference
        
        attribute :uuid
        attribute :last_updated
        attribute :other_config
        attribute :io_read_kbs
        attribute :io_write_kbs
        
        def initialize(attributes = {})
          super
          self.last_updated = attributes[:last_updated].to_time
        end
      end
      
    end
  end
end
