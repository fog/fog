require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/role'

module Fog
  module Identity
    class OpenStack
      class V3
        class Roles < Fog::Collection
          model Fog::Identity::OpenStack::V3::Role

          def all params={}
            load(service.list_roles(params).body['roles'])
          end

          def assignments params={}
            load(service.list_role_assignments(params).body['role_assignments'])
          end

          def find_by_id(id)
            cached_role = self.find { |role| role.id == id }
            return cached_role if cached_role
            role_hash = service.get_role(id).body['role']
            Fog::Identity::OpenStack::V3::role.new(
                role_hash.merge(:service => service))
          end

          def destroy(id)
            role = self.find_by_id(id)
            role.destroy
          end
        end
      end
    end
  end
end