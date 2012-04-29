module Fog
  module Compute
    class OpenStack
      class Real

        def deassociate_ip(server_id, ip)
          body = { "removeFloatingIp" => {"address" => ip}}
          server_action(server_id, body)
        end

      end

      class Mock

        def deassociate_ip(server_id, ip)
          raise "Not implemented"
        end

      end
    end
  end
end
