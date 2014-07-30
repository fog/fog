module Fog
  module Compute
    class Google
      class Mock
        def list_networks
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_networks
          api_method = @compute.networks.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
