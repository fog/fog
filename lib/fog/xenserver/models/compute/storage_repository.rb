require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class StorageRepository < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=SR
        
        identity :reference
        
        attribute :name,                 :aliases => :name_label
        attribute :description,          :aliases => :name_description
        attribute :uuid
        attribute :allowed_operations
        attribute :current_operations
        attribute :content_type
        attribute :other_config
        attribute :__pbds,               :aliases => :PBDs
        attribute :shared
        attribute :type
        attribute :tags
        attribute :__vdis,               :aliases => :VDIs
        attribute :physical_size
        attribute :physical_utilisation
        attribute :sm_config
        attribute :virtual_allocation
        
        def vdis
          __vdis.collect { |vdi| connection.vdis.get vdi }
        end
        
        def pbds
          __pbds.collect { |pbd| connection.pbds.get pbd }
        end

        def scan
          connection.scan_sr reference
          reload
        end

      end
      
    end
  end
end
