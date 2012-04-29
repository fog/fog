module Fog
  module Compute
    class OpenStack
      class Real

        def associate_ip(server_id, ip)
          body = { "addFloatingIp" => {"address" => ip}}
          server_action(server_id, body)
        end

      end

      class Mock

        def associate_ip(server_id, ip)
          raise "Not implemented"
        end

      end
    end
  end
end
