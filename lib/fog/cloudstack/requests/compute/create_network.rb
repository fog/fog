module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetwork.html]
        def create_network(options={})
          request(options)
        end


        def create_network(displaytext, zoneid, name, networkofferingid, options={})
          options.merge!(
            'command' => 'createNetwork', 
            'displaytext' => displaytext, 
            'zoneid' => zoneid, 
            'name' => name, 
            'networkofferingid' => networkofferingid  
          )
          request(options)
        end
      end

    end
  end
end

