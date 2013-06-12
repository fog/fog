require 'fog/core/collection'
require 'fog/openstack/models/volume/volume_type'

module Fog
  module Volume
    class OpenStack
      class VolumeTypes < Fog::Collection

        attribute :filters
        
        model Fog::Volume::OpenStack::VolumeType

        def initialize(attributes)
          self.filters ||= {}
          super
        end
        
        def all(filters = filters)
          self.filters = filters
          load(service.list_volume_types(filters).body['volume_types'])
        end

        def get(volume_type_id)
          if volume_type = service.get_volume_type(volume_type_id).body['volume_type']
            new(volume_type)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end

      end
    end
  end
end