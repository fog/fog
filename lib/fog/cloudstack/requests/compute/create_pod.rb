module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a new Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createPod.html]
        def create_pod(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createPod') 
          else
            options.merge!('command' => 'createPod', 
            'netmask' => args[0], 
            'zoneid' => args[1], 
            'name' => args[2], 
            'gateway' => args[3], 
            'startip' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

