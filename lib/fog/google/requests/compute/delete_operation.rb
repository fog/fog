module Fog
  module Compute
    class Google

      class Mock

        def delete_operation(operation_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def delete_operation(operation_name)
          api_method = @compute.operations.delete
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
