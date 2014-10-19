module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a network offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateNetworkOffering.html]
        def update_network_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateNetworkOffering') 
          else
            options.merge!('command' => 'updateNetworkOffering')
          end
          request(options)
        end
      end

    end
  end
end

