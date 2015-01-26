module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPaloAltoFirewallNetworks.html]
        def list_palo_alto_firewall_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPaloAltoFirewallNetworks') 
          else
            options.merge!('command' => 'listPaloAltoFirewallNetworks', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

