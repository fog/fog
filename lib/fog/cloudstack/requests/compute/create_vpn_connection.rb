module Fog
  module Compute
    class Cloudstack

      class Real
        # Create site to site vpn connection
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVpnConnection.html]
        def create_vpn_connection(s2scustomergatewayid, s2svpngatewayid, options={})
          options.merge!(
            'command' => 'createVpnConnection', 
            's2scustomergatewayid' => s2scustomergatewayid, 
            's2svpngatewayid' => s2svpngatewayid  
          )
          request(options)
        end
      end

    end
  end
end

