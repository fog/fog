require 'fog/ecloudv2/models/compute/api_key'

module Fog
  module Compute
    class Ecloudv2
      class ApiKeys < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::ApiKey

        def all
          data = connection.get_api_keys(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_api_key(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
