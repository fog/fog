require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/role'

module Fog
  module Identity
    class OpenStack
      class V3
        class RoleAssignments < Fog::Collection
          model Fog::Identity::OpenStack::V3::RoleAssignment

          def all
            filter_by {}
          end

          def filter_by params={}
            load(service.list_role_assignments(params).body['role_assignments'])
          end
        end
      end
    end
  end
end