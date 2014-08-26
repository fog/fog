module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal ping pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalPxePingServer.html]
        def add_baremetal_pxe_ping_server(options={})
          request(options)
        end


        def add_baremetal_pxe_ping_server(physicalnetworkid, pxeservertype, pingstorageserverip, url, tftpdir, password, pingdir, username, options={})
          options.merge!(
            'command' => 'addBaremetalPxePingServer', 
            'physicalnetworkid' => physicalnetworkid, 
            'pxeservertype' => pxeservertype, 
            'pingstorageserverip' => pingstorageserverip, 
            'url' => url, 
            'tftpdir' => tftpdir, 
            'password' => password, 
            'pingdir' => pingdir, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

