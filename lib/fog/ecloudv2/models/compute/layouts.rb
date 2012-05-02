require 'fog/ecloudv2/models/compute/layout'

module Fog
  module Compute
    class Ecloudv2
      class Layouts < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Layout

        def all
          data = connection.get_layouts(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_layout(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
