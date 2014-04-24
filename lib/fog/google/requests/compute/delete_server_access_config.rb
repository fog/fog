module Fog
  module Compute
    class Google

      class Mock
        def delete_server_access_config(identity, zone, nic, options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_server_access_config(identity, zone, nic, options = {})
          api_method = @compute.instances.delete_access_config
          parameters = {
            'project'  => @project,
            'instance' => identity,
            'zone'     => zone.split('/')[-1],
            'networkInterface' => nic,
            'accessConfig'     => options[:access_config].nil? ? 'External NAT' : options[:access_config],
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end

    end
  end
end
