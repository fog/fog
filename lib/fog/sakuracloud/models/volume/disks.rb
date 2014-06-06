require 'fog/core/collection'
require 'fog/sakuracloud/models/volume/disk'

module Fog
  module Volume
    class SakuraCloud
      class Disks < Fog::Collection
        model Fog::Volume::SakuraCloud::Disk

        def all
          load service.list_disks.body['Disks']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end

        def delete(id)
          service.delete_disk(id)
          true
        end
      end
    end
  end
end
