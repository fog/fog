module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a network serviceProvider to a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNetworkServiceProvider.html]
        def add_network_service_provider(options={})
          request(options)
        end


        def add_network_service_provider(name, physicalnetworkid, options={})
          options.merge!(
            'command' => 'addNetworkServiceProvider', 
            'name' => name, 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

