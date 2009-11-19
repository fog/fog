module Fog
  module Rackspace
    class Servers

      def addresses(attributes = {})
        Fog::AWS::EC2::Addresses.new({
          :connection => self
        }.merge!(attributes))
      end

      def images(attributes = {})
        Fog::Rackspace::Servers::Images.new({
          :connection => self
        }.merge!(attributes))
      end

      class Images < Fog::Collection

        model Fog::Rackspace::Servers::Image

        attribute :server

        def all
          data = connection.list_images_detail.body
          servers = Fog::Rackspace::Servers::Images.new({
            :connection => connection
          })
          for image in data['images']
            servers << Fog::Rackspace::Servers::Image.new({
              :collection => images,
              :connection => connection
            }.merge!(image))
          end
          if server
            images = images.select {|image| image.server_id == server.id}
          end
          images
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
