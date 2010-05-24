require 'fog/collection'
require 'fog/bluebox/models/image'

module Fog
  module Bluebox

    class Mock
      def images(attributes = {})
        Fog::Bluebox::Images.new({
          :connection => self
        }.merge!(attributes))
      end
    end

    class Real
      def images(attributes = {})
        Fog::Bluebox::Images.new({
          :connection => self
        }.merge!(attributes))
      end
    end

    class Templates < Fog::Collection

      model Fog::Bluebox::Image

      def all
        data = connection.get_templates.body['templates']
        load(data)
      end

      def get(template_id)
        connection.get_image(template_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
