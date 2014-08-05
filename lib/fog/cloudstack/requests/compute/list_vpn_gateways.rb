module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists site 2 site vpn gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVpnGateways.html]
        def list_vpn_gateways(options={})
          options.merge!(
            'command' => 'listVpnGateways'  
          )
          request(options)
        end
      end

    end
  end
end

