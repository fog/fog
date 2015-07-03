require 'fog/core/collection'
require 'fog/openstack/models/compute/volume'

module Fog
  module Compute
    class OpenStack
      class Volumes < Fog::Collection
        model Fog::Compute::OpenStack::Volume

        def all(options = true)
          if !options.is_a?(Hash)
            if options
              Fog::Logger.deprecation('Calling OpenStack[:compute].volumes.all(true) is deprecated, use .volumes.all')
            else
              Fog::Logger.deprecation('Calling OpenStack[:compute].volumes.all(false) is deprecated, use .volumes.summary')
            end
            load(service.list_volumes(options).body['volumes'])
          else
            load(service.list_volumes_detail(options).body['volumes'])
          end
        end

        def summary(options = {})
          load(service.list_volumes(options).body['volumes'])
        end

        def get(volume_id)
          if volume = service.get_volume_details(volume_id).body['volume']
            new(volume)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
