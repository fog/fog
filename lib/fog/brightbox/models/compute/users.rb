require 'fog/core/collection'
require 'fog/brightbox/models/compute/user'

module Fog
  module Brightbox
    class Compute

      class Users < Fog::Collection

        model Fog::Brightbox::Compute::User

        def all
          data = JSON.parse(connection.list_users.body)
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = JSON.parse(connection.get_user(identifier).body)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end