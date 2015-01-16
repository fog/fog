require 'fog/rackspace/models/networking_v2/security_group_rule'

module Fog
  module Rackspace
    class NetworkingV2
      class SecurityGroupRules < Fog::Collection
        model Fog::Rackspace::NetworkingV2::SecurityGroupRule

        def all
          data = service.list_security_group_rules.body['security_group_rules']
          load(data)
        end

        def get(id)
          data = service.show_security_group_rule(id).body['security_group_rule']
          new(data)
        rescue Fog::Rackspace::NetworkingV2::NotFound
          nil
        end
      end
    end
  end
end
