module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSrxFirewallNetworks.html]
        def list_srx_firewall_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSrxFirewallNetworks') 
          else
            options.merge!('command' => 'listSrxFirewallNetworks', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

