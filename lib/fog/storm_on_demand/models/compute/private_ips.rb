require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/private_ip'

module Fog
  module Compute
    class StormOnDemand

      class PrivateIps < Fog::Collection

        model Fog::Compute::StormOnDemand::PrivateIp

        def all
          data = service.list_private_ips.body['networks']
          load(data)
        end

        def get(server_id)
          if server_id && server = service.get_private_ip(private_ip).body
            new(server)
          elsif !server_id
            nil
          end
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
