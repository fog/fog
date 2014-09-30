module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Network Service Provider.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetworkServiceProvider.html]
        def delete_network_service_provider(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetworkServiceProvider') 
          else
            options.merge!('command' => 'deleteNetworkServiceProvider', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

