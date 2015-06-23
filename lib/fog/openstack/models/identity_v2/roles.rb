require 'fog/core/collection'
require 'fog/openstack/models/identity_v2/role'

module Fog
  module Identity
    class OpenStack
      class V2
        class Roles < Fog::Collection
          model Fog::Identity::OpenStack::V2::Role

          def all(options = {})
            load(service.list_roles(options).body['roles'])
          end

          alias_method :summary, :all

          def get(id)
            service.get_role(id)
          end
        end
      end # class V2
    end # class OpenStack
  end # module Identity
end # module Fog
