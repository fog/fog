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

        def get(role)
          connection.get_role(id)
        end

        def add_user_role(user, role, tenant)
          user_id = user.class == String ? user : user.id
          role_id = role.class == String ? role : role.id
          tenant_id = tenant.class == String ? tenant : tenant.id
          connection.create_user_role(tenant_id, user_id, role_id).status == 200
        end

        def remove_user_role(user, role, tenant)
          user_id = user.class == String ? user : user.id
          role_id = role.class == String ? role : role.id
          tenant_id = tenant.class == String ? tenant : tenant.id
          connection.delete_user_role(tenant_id, user_id, role_id).status == 200
        end

      end
    end # class OpenStack
  end # module Compute
end # module Fog
