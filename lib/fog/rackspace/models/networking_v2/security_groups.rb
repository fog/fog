require 'fog/rackspace/models/networking_v2/security_group'

module Fog
  module Rackspace
    class NetworkingV2
      class SecurityGroups < Fog::Collection
        model Fog::Rackspace::NetworkingV2::SecurityGroup

        def all
          data = service.list_security_groups.body['security_groups']
          load(data)
        end

        def get(id)
          data = service.show_security_group(id).body['security_group']
          new(data)
        rescue Fog::Rackspace::NetworkingV2::NotFound
          nil
        end
      end
    end
  end
end
