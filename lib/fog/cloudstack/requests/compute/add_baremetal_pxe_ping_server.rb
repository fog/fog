module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal ping pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalPxePingServer.html]
        def add_baremetal_pxe_ping_server(password, pxeservertype, pingstorageserverip, tftpdir, url, physicalnetworkid, pingdir, username, options={})
          options.merge!(
            'command' => 'addBaremetalPxePingServer', 
            'password' => password, 
            'pxeservertype' => pxeservertype, 
            'pingstorageserverip' => pingstorageserverip, 
            'tftpdir' => tftpdir, 
            'url' => url, 
            'physicalnetworkid' => physicalnetworkid, 
            'pingdir' => pingdir, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

