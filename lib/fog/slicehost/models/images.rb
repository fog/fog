require 'fog/collection'
require 'fog/slicehost/models/image'

module Fog
  module Slicehost

    class Mock
      def images(attributes = {})
        Fog::Slicehost::Images.new({
          :connection => self
        }.merge!(attributes))
      end
    end

    class Real
      def images(attributes = {})
        Fog::Slicehost::Images.new({
          :connection => self
        }.merge!(attributes))
      end
    end

    class Images < Fog::Collection

      model Fog::Slicehost::Image

      def all
        data = connection.get_images.body['images']
        load(data)
      end

      def get(image_id)
        connection.get_image(image_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
