module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a network offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createNetworkOffering.html]
        def create_network_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createNetworkOffering') 
          else
            options.merge!('command' => 'createNetworkOffering', 
            'traffictype' => args[0], 
            'guestiptype' => args[1], 
            'name' => args[2], 
            'supportedservices' => args[3], 
            'displaytext' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

