require 'fog/core/collection'
require 'fog/storm_on_demand/models/storage/volume'

module Fog
  module Storage
    class StormOnDemand

      class Volumes < Fog::Collection
        model Fog::Storage::StormOnDemand::Volume

        def create(options)
          vol = service.create_volume(options).body
          new(vol)
        end

        def get(uniq_id)
          vol = service.get_volume(:uniq_id => uniq_id).body
          new(vol)
        end

        def all(options={})
          vols = service.list_volumes(options).body['items']
          load(vols)
        end
        
      end

    end
  end
end
