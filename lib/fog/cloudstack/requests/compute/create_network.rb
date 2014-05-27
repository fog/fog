module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetwork.html]
        def create_network(options={})
          options.merge!(
            'command' => 'createNetwork', 
            'displaytext' => options['displaytext'], 
            'zoneid' => options['zoneid'], 
            'name' => options['name'], 
            'networkofferingid' => options['networkofferingid']  
          )
          request(options)
        end
      end

    end
  end
end

