module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a network offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createNetworkOffering.html]
        def create_network_offering(options={})
          options.merge!(
            'command' => 'createNetworkOffering',
            'supportedservices' => options['supportedservices'], 
            'guestiptype' => options['guestiptype'], 
            'traffictype' => options['traffictype'], 
            'displaytext' => options['displaytext'], 
            'name' => options['name'], 
             
          )
          request(options)
        end
      end

    end
  end
end

