require 'fog/core/collection'
require 'fog/profitbricks/models/compute/volume'

module Fog
    module Compute
        class ProfitBricks
            class Volumes < Fog::Collection
                model Fog::Compute::ProfitBricks::Volume

                def all
                    load(service.get_all_storages.body['getAllStoragesResponse'])
                end

                def get(id)
                    volume = service.get_storage(id).body['getStorageResponse']
                    Excon::Errors
                    new(volume)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end