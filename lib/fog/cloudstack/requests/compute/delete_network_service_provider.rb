module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network Service Provider.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetworkServiceProvider.html]
        def delete_network_service_provider(options={})
          options.merge!(
            'command' => 'deleteNetworkServiceProvider',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

