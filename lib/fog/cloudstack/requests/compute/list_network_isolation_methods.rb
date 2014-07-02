module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists supported methods of network isolation
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworkIsolationMethods.html]
        def list_network_isolation_methods(options={})
          options.merge!(
            'command' => 'listNetworkIsolationMethods'  
          )
          request(options)
        end
      end

    end
  end
end

