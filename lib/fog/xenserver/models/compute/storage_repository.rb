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

        def destroy
          connection.destroy_sr reference
        end
        
        def save
          requires :name
          requires :type

          # host is not a model attribute (not in XAPI at least), 
          # but we need it here
          host = attributes[:host]
          raise ArgumentError.new('host is required for this operation') unless
            host

          # Not sure if this is always required, so not raising exception if nil
          device_config = attributes[:device_config]

          # create_sr request provides sane defaults if some attributes are
          # missing
          attr = connection.get_record(
            connection.create_sr( host.reference, 
                                  name,
                                  type,
                                  description,
                                  device_config,
                                  physical_size,
                                  content_type,
                                  shared || false,
                                  sm_config),
            'SR'
          )
          merge_attributes attr 
          true
        end
        
        def set_attribute(name, *val)
          data = connection.set_attribute( 'SR', reference, name, *val )
          # Do not reload automatically for performance reasons
          # We can set multiple attributes at the same time and
          # then reload manually
          #reload
        end

      end
      
    end
  end
end
