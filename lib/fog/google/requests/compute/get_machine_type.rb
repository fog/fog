module Fog
  module Compute
    class Google

      class Mock

        def get_machine_type(machine_type_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_machine_type(machine_type_name)
          api_method = @compute.machine_types.get
          parameters = {
            'project' => 'google',
            'machineType' => machine_type_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
