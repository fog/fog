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
        attribute :reserved
        attribute :__vdi, :aliases => :VDI
        attribute :vm, :aliases => :VM
        attribute :device
        attribute :status_detail
        attribute :type
        attribute :userdevice
        
        #ignore_attributes :current_operations, :qos_supported_algorithms, :qos_algorithm_params, :qos_algorithm_type, :other_config,
        #                  :runtime_properties
        
        def initialize(attributes={})
          super
        end

        def vdi
          #Fog::Compute::XenServer::VDI.new(connection.get_record( __vdi, 'VDI' ))
          connection.vdis.get __vdi
        end

      end
      
    end
  end
end
