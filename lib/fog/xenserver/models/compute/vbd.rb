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
        attribute :storage_lock
        attribute :runtime_properties
        attribute :unpluggable
        attribute :bootable
        attribute :empty
        attribute :__metrics,           :aliases => :metrics

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

        def unplug
          connection.unplug_vbd reference
        end

        def unplug_force
          connection.unplug_force_vbd reference
        end
        
        def eject
          connection.eject_vbd reference
        end
        
        def insert(vdi)
          connection.insert_vbd reference, vdi.reference
        end

        def metrics
          rec = connection.get_record( __metrics, 'VBD_metrics' )
          Fog::Compute::XenServer::VbdMetrics.new(rec)
        end

      end
      
    end
  end
end
