module Fog
  module Compute
    class Cloudstack

      class Real
        # list baremetal pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listBaremetalPxeServers.html]
        def list_baremetal_pxe_servers(options={})
          options.merge!(
            'command' => 'listBaremetalPxeServers'  
          )
          request(options)
        end
      end

    end
  end
end

