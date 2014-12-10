require 'fog/core/collection'
require 'fog/rackspace/models/identity/user'

module Fog
  module Rackspace
    class Identity
      class Users < Fog::Collection
        model Fog::Rackspace::Identity::User

        def all
          data = service.list_users.body['users']
          load(data)
        end

        def get(user_id)
          data = service.get_user_by_id(user_id).body['user']
          new(data)
        rescue Excon::Errors::NotFound
          nil
        rescue Excon::Errors::Unauthorized
          nil
        end

        def get_by_name(user_name)
          data = service.get_user_by_name(user_name).body['user']
          new(data)
        rescue Excon::Errors::NotFound
          nil
        rescue Excon::Errors::Unauthorized
          nil
        end
      end
    end
  end
end
