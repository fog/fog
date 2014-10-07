module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_machine_types
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_aggregated_machine_types
          api_method = @compute.machine_types.aggregated_list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
