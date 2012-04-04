require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class VBD < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=VBD
        
        identity :reference
        
        attribute :uuid
        attribute :currently_attached
        attribute :allowed_operations
        attribute :current_operations
        attribute :reserved
        attribute :__vdi,               :aliases => :VDI
        attribute :__vm,                :aliases => :VM
        attribute :device
        attribute :status_detail
        attribute :status_code
        attribute :type
        attribute :userdevice
        attribute :empty
        attribute :type
        attribute :mode        
        attribute :runtime_properties
        attribute :unpluggable

        #
        # May return nil
        #
        def vdi
          connection.vdis.get __vdi
        end
        
        #
        # TODO: May it return nil?
        #
        def server
          connection.servers.get __vm
        end

      end
      
    end
  end
end
