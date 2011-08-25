require 'fog/core/collection'
require 'fog/brightbox/models/compute/user'

module Fog
  module Compute
    class Brightbox

      class Users < Fog::Collection

        model Fog::Compute::Brightbox::User

        def all
          data = connection.list_users
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.get_user(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end