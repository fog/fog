module Fog
  module Compute
    class Cloudstack

      class Real
        # list baremetal pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listBaremetalPxeServers.html]
        def list_baremetal_pxe_servers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listBaremetalPxeServers') 
          else
            options.merge!('command' => 'listBaremetalPxeServers')
          end
          request(options)
        end
      end

    end
  end
end

