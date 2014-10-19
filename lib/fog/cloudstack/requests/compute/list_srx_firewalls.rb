module Fog
  module Compute
    class Cloudstack

      class Real
        # lists SRX firewall devices in a physical network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSrxFirewalls.html]
        def list_srx_firewalls(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSrxFirewalls') 
          else
            options.merge!('command' => 'listSrxFirewalls')
          end
          request(options)
        end
      end

    end
  end
end

