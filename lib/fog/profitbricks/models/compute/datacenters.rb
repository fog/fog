require 'fog/core/collection'
require 'fog/profitbricks/models/compute/datacenter'

module Fog
    module Compute
        class ProfitBricks
            class Datacenters < Fog::Collection
                model Fog::Compute::ProfitBricks::Datacenter

                def all
                    load (service.get_all_data_centers.body['getAllDataCentersResponse'])
                end

                def get(id)
                    datacenter = service.get_data_center(id).body['getDataCenterResponse']
                    Excon::Errors
                    new(datacenter)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end