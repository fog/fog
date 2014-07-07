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

                def get(id)
                end
            end
        end
    end
end
