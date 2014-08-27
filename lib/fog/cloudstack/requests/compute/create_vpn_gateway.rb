module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates site to site vpn local gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVpnGateway.html]
        def create_vpn_gateway(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVpnGateway') 
          else
            options.merge!('command' => 'createVpnGateway', 
            'vpcid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

