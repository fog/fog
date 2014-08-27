module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a system virtual-machine that implements network services
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createServiceInstance.html]
        def create_service_instance(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createServiceInstance') 
          else
            options.merge!('command' => 'createServiceInstance', 
            'name' => args[0], 
            'rightnetworkid' => args[1], 
            'serviceofferingid' => args[2], 
            'leftnetworkid' => args[3], 
            'templateid' => args[4], 
            'zoneid' => args[5])
          end
          request(options)
        end
      end

    end
  end
end

