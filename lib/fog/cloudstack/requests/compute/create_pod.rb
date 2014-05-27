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
            'startip' => options['startip'], 
            'zoneid' => options['zoneid'], 
            'gateway' => options['gateway'], 
            'name' => options['name'], 
            'netmask' => options['netmask']  
          )
          request(options)
        end
      end

    end
  end
end

