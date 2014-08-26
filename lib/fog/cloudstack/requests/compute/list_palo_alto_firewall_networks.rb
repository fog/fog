module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPaloAltoFirewallNetworks.html]
        def list_palo_alto_firewall_networks(options={})
          request(options)
        end


        def list_palo_alto_firewall_networks(lbdeviceid, options={})
          options.merge!(
            'command' => 'listPaloAltoFirewallNetworks', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

