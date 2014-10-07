module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists site to site vpn connection gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVpnConnections.html]
        def list_vpn_connections(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVpnConnections') 
          else
            options.merge!('command' => 'listVpnConnections')
          end
          request(options)
        end
      end

    end
  end
end

