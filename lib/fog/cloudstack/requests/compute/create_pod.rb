module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a new Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPod.html]
        def create_pod(options={})
          options.merge!(
            'command' => 'createPod', 
            'netmask' => options['netmask'], 
            'name' => options['name'], 
            'startip' => options['startip'], 
            'gateway' => options['gateway'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

