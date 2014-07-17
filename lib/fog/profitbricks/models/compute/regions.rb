require 'fog/core/collection'
require 'fog/profitbricks/models/compute/region'

module Fog
    module Compute
        class ProfitBricks
            class Regions < Fog::Collection
                model Fog::Compute::ProfitBricks::Region

                def all(filters = {})
                    load (service.get_all_regions.body['getAllRegionsResponse'])
                end

                def get(id)
                    region = service.get_region(id).body['getRegionResponse']
                    Excon::Errors
                    new(region)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end