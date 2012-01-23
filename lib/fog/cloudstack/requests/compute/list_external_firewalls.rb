module Fog
  module Compute
    class Cloudstack
      class Real

        # List external firewall appliances.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listExternalFirewalls.html]
        def list_external_firewalls(options={})
          options.merge!(
            'command' => 'listExternalFirewalls'
          )
          
          request(options)
        end

      end
    end
  end
end
