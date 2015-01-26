module Fog
  module Compute
    class Google
      class Mock
        def delete_firewall(firewall_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_firewall(firewall_name)
          api_method = @compute.firewalls.delete
          parameters = {
            'project' => @project,
            'firewall' => firewall_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
