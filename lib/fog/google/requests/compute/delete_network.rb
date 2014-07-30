module Fog
  module Compute
    class Google
      class Mock
        def delete_network(network_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_network(network_name)
          api_method = @compute.networks.delete
          parameters = {
            'project' => @project,
            'network' => network_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
