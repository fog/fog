module Fog
  module Compute
    class Cloudstack

      class Real
        # Restarts the network; includes 1) restarting network elements - virtual routers, dhcp servers 2) reapplying all public ips 3) reapplying loadBalancing/portForwarding rules
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/restartNetwork.html]
        def restart_network(id, options={})
          options.merge!(
            'command' => 'restartNetwork', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

