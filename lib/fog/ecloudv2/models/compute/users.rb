require 'fog/ecloudv2/models/compute/user'

module Fog
  module Compute
    class Ecloudv2
      class Users < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::User

        def all
          data = connection.get_users(href).body[:User]
          load(data)
        end

        def get(uri)
          if data = connection.get_user(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
