require 'fog/collection'
require 'fog/bluebox/models/image'

module Fog
  module Bluebox

    module Collections
      def images(attributes = {})
        Fog::Bluebox::Images.new({
          :connection => self
        }.merge!(attributes))
      end
    end

    class Images < Fog::Collection

      model Fog::Bluebox::Image

      def all
        data = connection.get_templates.body
        load(data)
      end

      def get(template_id)
        response = connection.get_template(template_id)
        new(response.body)
      rescue Fog::Bluebox::NotFound
        nil
      end

    end

  end
end
