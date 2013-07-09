require 'fog/core/collection'
require 'fog/google/models/compute/disk'

module Fog
  module Compute
    class Google

      class Disks < Fog::Collection

        model Fog::Compute::Google::Disk

        def all(zone)
          data = service.list_disks(zone).body["items"]
          load(data)
        end

        def get(identity, zone)
          data = service.get_disk(identity, zone).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
