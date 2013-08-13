module Fog
  module Compute
    class Google

      class Mock

        def list_disks
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_disks(zone_name)
          api_method = @compute.disks.list
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
