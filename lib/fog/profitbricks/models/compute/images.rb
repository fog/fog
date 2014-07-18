require 'fog/core/collection'
require 'fog/profitbricks/models/compute/image'

module Fog
    module Compute
        class ProfitBricks
            class Images < Fog::Collection
                model Fog::Compute::ProfitBricks::Image

                def all(filters = {})
                    load (service.get_all_images.body['getAllImagesResponse'])
                end

                def get(id)
                    region = service.get_image(id).body['getImageResponse']
                    new(region)
                rescue Fog::Errors::NotFound
                    nil
                end
            end
        end
    end
end