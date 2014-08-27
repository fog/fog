module Fog
  module Compute
    class Cloudstack

      class Real
        # Reset site to site vpn connection
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/resetVpnConnection.html]
        def reset_vpn_connection(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'resetVpnConnection') 
          else
            options.merge!('command' => 'resetVpnConnection', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

