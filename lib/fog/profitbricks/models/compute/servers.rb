require 'fog/core/collection'
require 'fog/profitbricks/models/compute/server'

module Fog
    module Compute
        class ProfitBricks
            class Servers < Fog::Collection
                model Fog::Compute::ProfitBricks::Server

                def all(filters = {})
                end

                def bootstrap(new_attributes = {})
                end

                def get(data_center_id)
                    data_center = service.get_data_center(data_center_id).body['getDataCenterResponse']
                    new(data_center)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end