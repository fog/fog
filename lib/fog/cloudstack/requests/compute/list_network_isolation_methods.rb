module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists supported methods of network isolation
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetworkIsolationMethods.html]
        def list_network_isolation_methods(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetworkIsolationMethods') 
          else
            options.merge!('command' => 'listNetworkIsolationMethods')
          end
          request(options)
        end
      end

    end
  end
end

