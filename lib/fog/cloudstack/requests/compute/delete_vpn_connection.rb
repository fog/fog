module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete site to site vpn connection
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVpnConnection.html]
        def delete_vpn_connection(id, options={})
          options.merge!(
            'command' => 'deleteVpnConnection', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

