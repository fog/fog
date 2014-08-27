module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a network serviceProvider to a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addNetworkServiceProvider.html]
        def add_network_service_provider(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addNetworkServiceProvider') 
          else
            options.merge!('command' => 'addNetworkServiceProvider', 
            'name' => args[0], 
            'physicalnetworkid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

