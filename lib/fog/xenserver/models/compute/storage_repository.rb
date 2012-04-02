require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class StorageRepository < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=SR
        
        identity :reference
        
        attribute :name_label
        attribute :uuid
        attribute :allowed_operations
        attribute :content_type
        attribute :name_description
        attribute :other_config
        attribute :PBDs
        attribute :shared
        attribute :type
        attribute :VDIs
        
        ignore_attributes :blobs, :current_operations, :physical_size, :physical_utilisation, :sm_config, :tags,
                          :virtual_allocation
        
        def initialize(attributes={})
          @uuid ||= 0
          super
        end
        
      end
      
    end
  end
end
