module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a network serviceProvider to a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNetworkServiceProvider.html]
        def add_network_service_provider(options={})
          options.merge!(
            'command' => 'addNetworkServiceProvider',
            'name' => options['name'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

