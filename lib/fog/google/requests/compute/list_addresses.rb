module Fog
  module Compute
    class Google

      class Mock

        def list_addresses(region_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_addresses(region_name)
          api_method = @compute.addresses.list
          parameters = {
            'project' => @project,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
