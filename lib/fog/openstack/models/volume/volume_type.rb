require 'fog/core/model'

module Fog
  module Volume
    class OpenStack
      class VolumeType < Fog::Model
        identity :id

        attribute :name
        attribute :extra_specs

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save
          requires :name
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          create
        end

        def create
          requires :name
          merge_attributes(service.create_volume_type(self.name, 
                                                      self.attributes).body['volume_type'])
          self
        end
        
        def destroy
          requires :id
          service.delete_volume_type(self.id)
          true
        end

        def set_extra_spec(extra_spec_key, extra_spec_value)
          requires :id
          service.set_volume_type_extra_spec(self.id, extra_spec_key, extra_spec_value)
          true
        end
        
        def unset_extra_spec(extra_spec_key)
          requires :id
          service.unset_volume_type_extra_spec(self.id, extra_spec_key)
          true
        end
        
      end
    end
  end
end