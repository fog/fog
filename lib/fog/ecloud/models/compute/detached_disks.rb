require 'fog/ecloud/models/compute/detached_disk'

module Fog
  module Compute
    class Ecloud
      class DetachedDisks < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::DetachedDisk

        def all
          data = service.get_detached_disks(href).body[:DetachedDisk]
					data = [] if data.nil?
          load(data)
        end

        def get(uri)
          data = service.get_detached_disk(uri).body
          new(data)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
