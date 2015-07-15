require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v3/policy'

module Fog
  module Identity
    class OpenStack
      class V3
        class Policies < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V3::Policy

          def all(options = {})
            load_response(service.list_policies(options), 'policies')
          end

          def find_by_id(id)
            cached_policy = self.find { |policy| policy.id == id }
            return cached_policy if cached_policy
            policy_hash = service.get_policy(id).body['policy']
            Fog::Identity::OpenStack::V3::Policy.new(
                policy_hash.merge(:service => service))
          end

          def destroy(id)
            policy = self.find_by_id(id)
            policy.destroy
          end
        end
      end
    end
  end
end
