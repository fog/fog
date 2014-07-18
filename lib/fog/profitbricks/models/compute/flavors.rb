require 'fog/core/collection'
require 'fog/profitbricks/models/compute/flavor'

module Fog
    module Compute
        class ProfitBricks
            class Flavors < Fog::Collection
                model Fog::Compute::ProfitBricks::Flavor

                def all()
                    load (service.get_all_flavors.body['getAllFlavorsResponse'])
                end

                def get(id)
                    flavor = service.get_flavor(id).body['getFlavorResponse']
                    Excon::Errors
                    new(flavor)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end