module Fog
  module Compute
    class Cloudstack

      class Real
        # Create site to site vpn connection
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVpnConnection.html]
        def create_vpn_connection(options={})
          options.merge!(
            'command' => 'createVpnConnection', 
            's2svpngatewayid' => options['s2svpngatewayid'], 
            's2scustomergatewayid' => options['s2scustomergatewayid']  
          )
          request(options)
        end
      end

    end
  end
end

