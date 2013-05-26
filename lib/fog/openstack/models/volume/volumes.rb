require 'fog/core/collection'
require 'fog/openstack/models/volume/volume'

module Fog
  module Volume
    class OpenStack
      class Volumes < Fog::Collection
        
        attribute :filters

        model Fog::Volume::OpenStack::Volume

        def initialize(attributes)
          self.filters ||= {}
          super
        end
        
        def all(detailed = true, filters = filters)
          self.filters = filters
          load(service.list_volumes(detailed, filters).body['volumes'])
        end

        def get(volume_id)
          if volume = service.get_volume_details(volume_id).body['volume']
            new(volume)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end
        alias_method :find_by_id, :get

      end
    end
  end
end