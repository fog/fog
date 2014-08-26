module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists site to site vpn connection gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVpnConnections.html]
        def list_vpn_connections(options={})
          options.merge!(
            'command' => 'listVpnConnections'  
          )
          request(options)
        end
      end

    end
  end
end

