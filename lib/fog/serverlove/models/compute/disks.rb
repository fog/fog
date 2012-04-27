require 'fog/core/collection'
require 'fog/serverlove/models/compute/disk'

module Fog
  module Compute
    class Serverlove

      class Disks < Fog::Collection

        model Fog::Compute::Serverlove::Disk

        def all
          data = connection.get_disks.body['disks']
          load(data)
        end

        def get(disk_id)
          connection.get_disk(image_id)
        end

      end

    end
  end
end
