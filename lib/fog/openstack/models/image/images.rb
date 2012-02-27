require 'fog/core/collection'
require 'fog/openstack/models/image/image'

module Fog
  module Image
    class OpenStack
      class Images < Fog::Collection
        model Fog::Image::OpenStack::Image

        def all
          load(connection.list_public_images_detailed.body['images'])
        end

        def details
          load(connection.list_public_images_detailed.body['images'])
        end

        def find_by_id(id)
          self.find {|image| image.id == id} ||
            Fog::Image::OpenStack::Image.new(
              connection.get_image(id).body['image'])
        end

        def destroy(id)
          image = self.find_by_id(id)
          image.destroy
        end
      end
    end
  end
end
