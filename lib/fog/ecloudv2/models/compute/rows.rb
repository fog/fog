require 'fog/ecloudv2/models/compute/row'

module Fog
  module Compute
    class Ecloudv2
      class Rows < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Row

        def all
          data = connection.get_layout(href).body[:Rows][:Row]
          load(data)
        end

        def get(uri)
          if data = connection.get_row(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
