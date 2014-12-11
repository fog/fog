require 'fog/core/collection'
require 'fog/rackspace/models/identity/role'

module Fog
  module Rackspace
    class Identity
      class Roles < Fog::Collection
        model Fog::Rackspace::Identity::Role

        attr_accessor :user

        def all
          requires :user
          load(retrieve_roles)
        end

        def get(id)
          requires :user
          data = retrieve_roles.find{ |role| role['id'] == id }
          data && new(data)
        end

        private

        def retrieve_roles
          data = service.list_user_roles(user.identity).body['roles']
        end
      end
    end
  end
end
