module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a network serviceProvider of a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateNetworkServiceProvider.html]
        def update_network_service_provider(id, options={})
          options.merge!(
            'command' => 'updateNetworkServiceProvider', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

