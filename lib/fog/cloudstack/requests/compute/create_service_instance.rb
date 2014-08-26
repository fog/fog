module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a system virtual-machine that implements network services
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createServiceInstance.html]
        def create_service_instance(options={})
          request(options)
        end


        def create_service_instance(name, rightnetworkid, serviceofferingid, leftnetworkid, templateid, zoneid, options={})
          options.merge!(
            'command' => 'createServiceInstance', 
            'name' => name, 
            'rightnetworkid' => rightnetworkid, 
            'serviceofferingid' => serviceofferingid, 
            'leftnetworkid' => leftnetworkid, 
            'templateid' => templateid, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

