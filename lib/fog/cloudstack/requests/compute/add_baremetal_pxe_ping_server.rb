module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal ping pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalPxePingServer.html]
        def add_baremetal_pxe_ping_server(options={})
          options.merge!(
            'command' => 'addBaremetalPxePingServer', 
            'password' => options['password'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'pingdir' => options['pingdir'], 
            'tftpdir' => options['tftpdir'], 
            'url' => options['url'], 
            'username' => options['username'], 
            'pingstorageserverip' => options['pingstorageserverip'], 
            'pxeservertype' => options['pxeservertype']  
          )
          request(options)
        end
      end

    end
  end
end

