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
          if @loaded
            clear
          end
          @loaded = true
          data = connection.list_images_detail.body
          images = []
          for image in data['images']
            images << new(image)
          end
          if server
            images = images.select {|image| image.server_id == server.id}
          end
          self.replace(images)
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
