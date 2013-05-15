module Fog
  module Compute
    class Google

      class Mock

        def list_global_operations
          Fog::Mock.not_implemented
        end

      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/globalOperations

        def list_global_operations
          api_method = @compute.global_operations.list
          parameters = {
            'project' => @project
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
