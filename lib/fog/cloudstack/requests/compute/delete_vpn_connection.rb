module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete site to site vpn connection
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteVpnConnection.html]
        def delete_vpn_connection(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteVpnConnection') 
          else
            options.merge!('command' => 'deleteVpnConnection', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

