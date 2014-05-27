module Fog
  module Compute
    class Cloudstack

      class Real
        # lists SRX firewall devices in a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSrxFirewalls.html]
        def list_srx_firewalls(options={})
          options.merge!(
            'command' => 'listSrxFirewalls'  
          )
          request(options)
        end
      end

    end
  end
end

