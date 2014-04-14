module Fog
  module Compute
    class Google

      class Mock
        def list_aggregated_addresses
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_aggregated_addresses
          api_method = @compute.addresses.aggregated_list
          parameters = {
            'project' => @project,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end

    end
  end
end
