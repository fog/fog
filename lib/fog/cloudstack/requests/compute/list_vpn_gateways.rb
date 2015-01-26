module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists site 2 site vpn gateways
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVpnGateways.html]
        def list_vpn_gateways(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVpnGateways') 
          else
            options.merge!('command' => 'listVpnGateways')
          end
          request(options)
        end
      end

    end
  end
end

