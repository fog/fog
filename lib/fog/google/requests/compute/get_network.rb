module Fog
  module Compute
    class Google
      class Mock
        def get_network(network_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_network(network_name)
          api_method = @compute.networks.get
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
