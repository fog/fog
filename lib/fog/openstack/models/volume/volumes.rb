require 'fog/core/collection'
require 'fog/openstack/models/volume/volume'

module Fog
  module Volume
    class OpenStack

      class Volumes < Fog::Collection
        model Fog::Volume::OpenStack::Volume

        def all(options = {:detailed => true})
          # the parameter has been "detailed = true" before. Make sure we are
          # backwards compatible
          detailed = options.is_a?(Hash) ? options.delete(:detailed) : options
          load(service.list_volumes(detailed, options).body['volumes'])
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

