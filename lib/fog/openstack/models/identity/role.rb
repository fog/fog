require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class Role < Fog::Model
        identity :id
        attribute :name

        def save
          requires :name
          data = service.create_role(name)
          merge_attributes(data.body['role'])
          true
        end

        def destroy
          requires :id
          service.delete_role(id)
          true
        end

        def add_to_user(user, tenant)
          add_remove_to_user(user, tenant, :add)
        end

        def remove_to_user(user, tenant)
          add_remove_to_user(user, tenant, :remove)
        end

        private
        def add_remove_to_user(user, tenant, ops)
          requires :id
          user_id = get_id(user)
          tenant_id = get_id(tenant)
          case ops
          when :add
            service.create_user_role(tenant_id, user_id, id).status == 200
          when :remove
            service.delete_user_role(tenant_id, user_id, id).status == 204
          end
        end

        def get_id(_)
          _.is_a?(String) ? _ : _.id
        end
      end # class Role
    end # class OpenStack
  end # module Identity
end # module Fog
