module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalPxeKickStartServer.html]
        def add_baremetal_pxe_kick_start_server(options={})
          request(options)
        end


        def add_baremetal_pxe_kick_start_server(url, username, tftpdir, pxeservertype, password, physicalnetworkid, options={})
          options.merge!(
            'command' => 'addBaremetalPxeKickStartServer', 
            'url' => url, 
            'username' => username, 
            'tftpdir' => tftpdir, 
            'pxeservertype' => pxeservertype, 
            'password' => password, 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

