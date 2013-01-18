require 'fog/ecloud/models/compute/layout'

module Fog
  module Compute
    class Ecloud
      class Layouts < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Layout

        def all
          data = service.get_layouts(href).body
          load(data)
        end

        def get(uri)
          if data = service.get_layout(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
