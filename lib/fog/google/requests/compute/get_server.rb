module Fog
  module Compute
    class Google

      class Mock

        def get_server(server_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_server(server_name, zone_name)
          api_method = @compute.instances.get
          parameters = {
            'project' => @project,
            'zone' => zone_name,
            'instance' => server_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
