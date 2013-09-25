module Fog
  module Compute
    class Google

      class Mock

        def list_servers
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_servers(zone_name)
          api_method = @compute.instances.list
          parameters = {
            'project' => @project,
            'zone' => zone_name,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
