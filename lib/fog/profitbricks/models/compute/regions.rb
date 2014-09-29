require 'fog/core/collection'
require 'fog/profitbricks/models/compute/region'

module Fog
    module Compute
        class ProfitBricks
            class Regions < Fog::Collection
                model Fog::Compute::ProfitBricks::Region

                def all()
                    load (service.get_all_locations.body['getAllLocationsResponse'])
                end

                def get(id)
                    region = service.get_location(id).body['getLocationResponse']
                    Excon::Errors
                    new(region)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end