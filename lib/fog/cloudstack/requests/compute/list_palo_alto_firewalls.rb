module Fog
  module Compute
    class Cloudstack

      class Real
        # lists Palo Alto firewall devices in a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPaloAltoFirewalls.html]
        def list_palo_alto_firewalls(options={})
          request(options)
        end


        def list_palo_alto_firewalls(options={})
          options.merge!(
            'command' => 'listPaloAltoFirewalls'  
          )
          request(options)
        end
      end

    end
  end
end

