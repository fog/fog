require 'fog/core/model'

module Fog
  module Compute
    class XenServer
    
      class Pool < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=pool
        
        identity :reference
        
        attribute :name_label
        attribute :uuid
        attribute :__default_sr,           :aliases => :default_SR
        
        def initialize(attributes={})
          @uuid ||= 0
          super
        end

        def default_sr
          connection.get_storage_repository_by_ref __default_sr
        end

        def default_storage_repository
          connection.get_storage_repository_by_ref __default_sr
        end

      end
      
    end
  end
end
