module Fog
  module Compute
    class Google
      class Mock
        def set_server_scheduling(identity, zone, on_host_maintenance, automatic_restart)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_server_scheduling(identity, zone, on_host_maintenance, automatic_restart)
          api_method = @compute.instances.set_scheduling
          parameters = {
            'project'  => @project,
            'instance' => identity,
            'zone'     => zone.split('/')[-1],
          }

          body_object = {
            'onHostMaintenance' => on_host_maintenance,
            'automaticRestart'  => automatic_restart,
          }

          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
