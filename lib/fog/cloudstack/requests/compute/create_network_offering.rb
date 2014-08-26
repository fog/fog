module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a network offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetworkOffering.html]
        def create_network_offering(guestiptype, traffictype, name, supportedservices, displaytext, options={})
          options.merge!(
            'command' => 'createNetworkOffering', 
            'guestiptype' => guestiptype, 
            'traffictype' => traffictype, 
            'name' => name, 
            'supportedservices' => supportedservices, 
            'displaytext' => displaytext  
          )
          request(options)
        end
      end

    end
  end
end

