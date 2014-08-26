module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a new Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPod.html]
        def create_pod(netmask, name, startip, gateway, zoneid, options={})
          options.merge!(
            'command' => 'createPod', 
            'netmask' => netmask, 
            'name' => name, 
            'startip' => startip, 
            'gateway' => gateway, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

