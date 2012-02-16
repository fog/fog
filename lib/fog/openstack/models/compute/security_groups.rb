require 'fog/core/collection'
require 'fog/openstack/models/compute/security_group'

module Fog
  module Compute
    class Openstack

      class SecurityGroups < Fog::Collection

        model Fog::Compute::Openstack::SecurityGroup

        def all
          load(connection.list_security_groups.body['security_groups'])
        end

        def get(security_group_id)
          if security_group_id
            new(connection.get_security_group(security_group_id).body['security_group'])
          end
        rescue Fog::Compute::Openstack::NotFound
          nil
        end

      end
    end
  end
end