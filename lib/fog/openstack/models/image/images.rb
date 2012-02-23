require 'fog/core/collection'
require 'fog/openstack/models/image/image'

module Fog
  module Image
    class OpenStack
      class Images < Fog::Collection
        model Fog::Image::OpenStack::Image

        def all
          load(connection.list_public_images.body['images'])
        end
      end
    end
  end
end
