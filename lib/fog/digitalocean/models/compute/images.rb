require 'fog/core/collection'
require 'fog/digitalocean/models/compute/image'

module Fog
  module Compute
    class DigitalOcean
      class Images < Fog::Collection
        model Fog::Compute::DigitalOcean::Image

        def all
          load service.list_images.body['images']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
