module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all network services provided by CloudStack or for the given Provider.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSupportedNetworkServices.html]
        def list_supported_network_services(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSupportedNetworkServices') 
          else
            options.merge!('command' => 'listSupportedNetworkServices')
          end
          request(options)
        end
      end

    end
  end
end

