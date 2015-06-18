require 'fog/core/collection'
require 'fog/openstack/models/compute/security_group'

module Fog
  module Compute
    class OpenStack
      class SecurityGroups < Fog::Collection
        model Fog::Compute::OpenStack::SecurityGroup

        def all(options = {})
          load(service.list_security_groups(options).body['security_groups'])
        end

        alias_method :summary, :all

        def get(security_group_id)
          if security_group_id
            new(service.get_security_group(security_group_id).body['security_group'])
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
