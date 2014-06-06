module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalPxeKickStartServer.html]
        def add_baremetal_pxe_kick_start_server(username, url, physicalnetworkid, password, pxeservertype, tftpdir, options={})
          options.merge!(
            'command' => 'addBaremetalPxeKickStartServer', 
            'username' => username, 
            'url' => url, 
            'physicalnetworkid' => physicalnetworkid, 
            'password' => password, 
            'pxeservertype' => pxeservertype, 
            'tftpdir' => tftpdir  
          )
          request(options)
        end
      end

    end
  end
end

