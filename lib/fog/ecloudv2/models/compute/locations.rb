require 'fog/ecloudv2/models/compute/location'

module Fog
  module Compute
    class Ecloudv2

      class Locations < Fog::Ecloudv2::Collection

        model Fog::Compute::Ecloudv2::Location

        undef_method :create

        identity :href

        def all
          data = connection.get_organization(href).body[:Locations][:Location]
          load(data)
        end

        def get(uri)
          if data = connection.get_location(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
