module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a network serviceProvider of a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateNetworkServiceProvider.html]
        def update_network_service_provider(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateNetworkServiceProvider') 
          else
            options.merge!('command' => 'updateNetworkServiceProvider', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

