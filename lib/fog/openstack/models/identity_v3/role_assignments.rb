require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/role'

module Fog
  module Identity
    class OpenStack
      class V3
        class RoleAssignments < Fog::Collection
          model Fog::Identity::OpenStack::V3::RoleAssignment

          def all(options = {})
            load(service.list_role_assignments(options).body['role_assignments'])
          end

          alias_method :summary, :all

          def filter_by(options = {})
            Fog::Logger.deprecation("Calling OpenStack[:keystone].role_assignments.filter_by(options) method which"\
                                    " is not part of standard interface and is deprecated, call "\
                                    " .role_assignments.all(options) or .role_assignments.summary(options) instead.")
            all(options)
          end
        end
      end
    end
  end
end
