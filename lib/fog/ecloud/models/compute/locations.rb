require 'fog/ecloud/models/compute/location'

module Fog
  module Compute
    class Ecloud

      class Locations < Fog::Ecloud::Collection

        model Fog::Compute::Ecloud::Location

        undef_method :create

        identity :href

        def all
          data = service.get_organization(href).body[:Locations][:Location]
          load(data)
        end

        def get(uri)
          if data = service.get_location(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
