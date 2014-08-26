module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates site to site vpn local gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVpnGateway.html]
        def update_vpn_gateway(options={})
          request(options)
        end


        def update_vpn_gateway(id, options={})
          options.merge!(
            'command' => 'updateVpnGateway', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

