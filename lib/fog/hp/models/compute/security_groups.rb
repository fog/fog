require 'fog/core/collection'
require 'fog/hp/models/compute/security_group'

module Fog
  module Compute
    class HP
      class SecurityGroups < Fog::Collection
        model Fog::Compute::HP::SecurityGroup

        def all
          items = service.list_security_groups.body['security_groups']
          load(items)
        end

        def get(security_group_id)
          if security_group_id
            sec_group = service.get_security_group(security_group_id).body['security_group']
            new(sec_group)
          end
        rescue Fog::Compute::HP::NotFound
          nil
        end
      end
    end
  end
end
