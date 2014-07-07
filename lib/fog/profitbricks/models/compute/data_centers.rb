require 'fog/core/collection'
require 'fog/profitbricks/models/compute/server'

module Fog
    module Compute
        class ProfitBricks
            class DataCenters < Fog::Collection
                model Fog::Compute::ProfitBricks::DataCenter

                def all(filters = {})
                end

                def get(id)
                    new service.get_data_center(id)
                end
            end
        end
    end
end
