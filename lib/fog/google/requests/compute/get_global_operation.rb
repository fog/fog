module Fog
  module Compute
    class Google

      class Mock

        def get_global_operation(operation_name)
          Fog::Mock.not_implemented
        end

      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/globalOperations

        def get_global_operation(operation_name)
          api_method = @compute.global_operations.get
          parameters = {
            'project' => @project,
            'operation' => operation_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
