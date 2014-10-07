require 'fog/core/collection'
require 'fog/bluebox/models/compute/image'

module Fog
  module Compute
    class Bluebox
      class Images < Fog::Collection
        model Fog::Compute::Bluebox::Image

        def all
          data = service.get_templates.body
          load(data)
        end

        def get(template_id)
          response = service.get_template(template_id)
          new(response.body)
        rescue Fog::Compute::Bluebox::NotFound
          nil
        end
      end
    end
  end
end
