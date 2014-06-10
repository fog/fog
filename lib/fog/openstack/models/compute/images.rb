require 'fog/core/collection'
require 'fog/openstack/models/compute/image'

module Fog
  module Compute
    class OpenStack
      class Images < Fog::Collection
        attribute :filters

        model Fog::Compute::OpenStack::Image

        attribute :server

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = service.list_images_detail(filters).body['images']
          images = load(data)
          if server
            self.replace(self.select {|image| image.server_id == server.id})
          end
          images
        end

        def get(image_id)
          data = service.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
