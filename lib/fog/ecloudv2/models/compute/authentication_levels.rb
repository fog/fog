require 'fog/ecloudv2/models/compute/authentication_level'

module Fog
  module Compute
    class Ecloudv2
      class AuthenticationLevels < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::AuthenticationLevel

        def all
          data = connection.get_authentication_levels(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_authentication_level(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
