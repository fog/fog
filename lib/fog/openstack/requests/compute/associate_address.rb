module Fog
  module Compute
    class OpenStack
      class Real

        def associate_address(server_id, ip_address)
          body = { "addFloatingIp" => {"address" => ip_address}}
          server_action(server_id, body)
        end

      end

      class Mock



      end
    end
  end
end
