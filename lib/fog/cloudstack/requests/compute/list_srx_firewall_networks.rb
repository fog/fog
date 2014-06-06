module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSrxFirewallNetworks.html]
        def list_srx_firewall_networks(lbdeviceid, options={})
          options.merge!(
            'command' => 'listSrxFirewallNetworks', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

