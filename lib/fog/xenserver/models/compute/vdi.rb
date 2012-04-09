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
        attribute :virtual_size
        attribute :__vbds, :aliases => :VBDs
        attribute :__sr, :aliases => :SR
        attribute :sharable
        attribute :read_only
        attribute :current_operations
        attribute :allowed_operations
        attribute :type
        attribute :other_config
        
        #
        # Default VDI type is system
        # Default size 8GB
        # Sharable is false by default
        # read_only is false by default
        #
        def initialize(attributes = {})
          self.virtual_size ||= '8589934592' unless attributes[:virtual_size]
          self.type ||= 'system' unless attributes[:type]
          self.read_only ||= false unless attributes[:read_only]
          self.sharable ||= false unless attributes[:sharable]
          self.other_config ||= {} unless attributes[:other_config]
          super 
        end

        def save
          requires :name, :storage_repository
          ref = connection.create_vdi attributes
          merge_attributes connection.vdis.get(ref).attributes
        end

        def destroy
          connection.destroy_vdi reference
        end

        def storage_repository
          connection.storage_repositories.get __sr
        end

        def sr
          storage_repository
        end

      end
      
    end
  end
end
