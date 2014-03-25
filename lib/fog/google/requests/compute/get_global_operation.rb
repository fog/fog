module Fog
  module Compute
    class Google

      class Mock

        def get_global_operation(operation)
          Fog::Mock.not_implemented
        end

      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/globalOperations

        def get_global_operation(operation)
          api_method = @compute.global_operations.get
          parameters = {
            'project' => @project,
            'operation' => operation
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
