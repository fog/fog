module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a new Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPod.html]
        def create_pod(options={})
          request(options)
        end


        def create_pod(netmask, zoneid, name, gateway, startip, options={})
          options.merge!(
            'command' => 'createPod', 
            'netmask' => netmask, 
            'zoneid' => zoneid, 
            'name' => name, 
            'gateway' => gateway, 
            'startip' => startip  
          )
          request(options)
        end
      end

    end
  end
end

