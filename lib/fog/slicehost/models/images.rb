module Fog
  class Slicehost

    def images(attributes = {})
      Fog::Slicehost::Images.new({
        :connection => self
      }.merge!(attributes))
    end

    class Images < Fog::Collection

      model Fog::Slicehost::Image

      def all
        if @loaded
          clear
        end
        @loaded = true
        data = connection.get_images.body
        for image in data['images']
          self << new(image)
        end
        self
      end

      def get(image_id)
        connection.get_image(image_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
