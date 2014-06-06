module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetwork.html]
        def create_network(displaytext, name, networkofferingid, zoneid, options={})
          options.merge!(
            'command' => 'createNetwork', 
            'displaytext' => displaytext, 
            'name' => name, 
            'networkofferingid' => networkofferingid, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

