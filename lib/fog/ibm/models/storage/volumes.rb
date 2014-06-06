require 'fog/core/collection'
require 'fog/ibm/models/storage/volume'

module Fog
  module Storage
    class IBM
      class Volumes < Fog::Collection
        model Fog::Storage::IBM::Volume

        def all
          load(service.list_volumes.body['volumes'])
        end

        def get(volume_id)
          begin
            new(service.get_volume(volume_id).body)
          rescue Fog::Storage::IBM::NotFound
            nil
          end
        end
      end
    end
  end
end
