module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a network offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetworkOffering.html]
        def delete_network_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetworkOffering') 
          else
            options.merge!('command' => 'deleteNetworkOffering', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

