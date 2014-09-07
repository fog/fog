module Fog
  module Compute
    class Cloudstack

      class Real
        # list baremetal dhcp servers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listBaremetalDhcp.html]
        def list_baremetal_dhcp(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listBaremetalDhcp') 
          else
            options.merge!('command' => 'listBaremetalDhcp')
          end
          request(options)
        end
      end

    end
  end
end

