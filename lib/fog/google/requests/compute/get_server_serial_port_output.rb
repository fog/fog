module Fog
  module Compute
    class Google

      class Mock
        def get_server_serial_port_output(identity, zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_server_serial_port_output(identity, zone)
          api_method = @compute.instances.get_serial_port_output
          parameters = {
            'project'  => @project,
            'instance' => identity,
            'zone'     => zone.split('/')[-1],
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end

    end
  end
end
