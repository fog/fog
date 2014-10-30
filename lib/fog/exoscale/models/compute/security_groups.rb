require 'fog/core/collection'
require 'fog/exoscale/models/compute/security_group'

module Fog
  module Compute
    class Exoscale
      class SecurityGroups < Fog::Collection
        model Fog::Compute::Exoscale::SecurityGroup

        def all(options={})
          data = service.list_security_groups(options)["listsecuritygroupsresponse"]["securitygroup"] || []
          load(data)
        end

        def get(security_group_id)
          if security_group = service.list_security_groups('id' => security_group_id)["listsecuritygroupsresponse"]["securitygroup"].first
            new(security_group)
          end
        rescue Fog::Compute::Exoscale::BadRequest
          nil
        end
      end
    end
  end
end
