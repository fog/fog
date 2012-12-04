module Fog
  module Compute
    class Google

      class Mock

        def list_machine_types
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_machine_types
          api_method = @compute.machine_types.list
          parameters = {
            'project' => 'google'
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
