module Fog
  module Rackspace
    class Servers

      def images(attributes = {})
        Fog::Rackspace::Servers::Images.new({
          :connection => self
        }.merge!(attributes))
      end

      class Images < Fog::Collection

        model Fog::Rackspace::Servers::Image

        attribute :server

        def all
          data = connection.list_images_detail.body['images']
          load(images)
          if server
            self.replace(self.select {|image| image.server_id == server.id})
          end
        end

        def get(image_id)
          connection.get_image_details(image_id)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
