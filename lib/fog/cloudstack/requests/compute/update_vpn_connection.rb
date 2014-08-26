module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates site to site vpn connection
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVpnConnection.html]
        def update_vpn_connection(options={})
          request(options)
        end


        def update_vpn_connection(id, options={})
          options.merge!(
            'command' => 'updateVpnConnection', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

