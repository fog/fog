require 'fog/ecloud/models/compute/detached_disk'

module Fog
  module Compute
    class Ecloud
      class DetachedDisks < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::DetachedDisk

        def all
          data = connection.get_detached_disks(href).body[:DetachedDisk]
					data = [] if data.nil?
          load(data)
        end

        def get(uri)
          data = connection.get_detached_disk(uri).body
          if data == ""
            new({})
          else
            new(data)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
