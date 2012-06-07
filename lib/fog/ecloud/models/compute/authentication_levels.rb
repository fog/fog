require 'fog/ecloud/models/compute/authentication_level'

module Fog
  module Compute
    class Ecloud
      class AuthenticationLevels < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::AuthenticationLevel

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
