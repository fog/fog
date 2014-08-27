module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete site to site vpn gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteVpnGateway.html]
        def delete_vpn_gateway(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteVpnGateway') 
          else
            options.merge!('command' => 'deleteVpnGateway', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

