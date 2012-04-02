require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class VDI < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=VDI
        
        identity :reference
        
        attribute :uuid
        attribute :is_a_snapshot
        attribute :name, :aliases => :name_label
        attribute :description, :aliases => :name_description
        attribute :__parent, :aliases => :parent
        attribute :virtual_size, :aliases => :parent
        attribute :__vbds, :aliases => :VBDs
        attribute :__sr, :aliases => :SR
        attribute :sharable
        attribute :readonly
        
        def initialize(attributes={})
          @uuid ||= 0
          super
        end

      end
      
    end
  end
end
