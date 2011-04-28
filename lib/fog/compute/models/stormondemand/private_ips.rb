require 'fog/core/collection'
require 'fog/compute/models/stormondemand/private_ip'

module Fog
  module Stormondemand
    class Compute

      class PrivateIps < Fog::Collection

        model Fog::Stormondemand::Compute::PrivateIp

        def all
          data = connection.list_private_ips.body['networks']
          load(data)
        end

        def get(server_id)
          if server_id && server = connection.get_private_ip(private_ip).body
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
