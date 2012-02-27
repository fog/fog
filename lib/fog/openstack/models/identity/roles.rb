require 'fog/core/collection'
require 'fog/openstack/models/identity/role'

module Fog
  module Identity
    class OpenStack
      class Roles < Fog::Collection
        model Fog::Identity::OpenStack::Role

        attribute :user
        attribute :tenant

        def all
          requires :user, :tenant
          load(connection.
            list_roles_for_user_on_tenant(tenant.id, user.id).body['roles'])
        end

        def get(id)
          connection.get_role(id)
        end

      end
    end # class OpenStack
  end # module Compute
end # module Fog
