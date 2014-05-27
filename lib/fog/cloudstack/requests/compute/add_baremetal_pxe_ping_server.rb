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
            'pingdir' => options['pingdir'], 
            'username' => options['username'], 
            'url' => options['url'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'pxeservertype' => options['pxeservertype'], 
            'pingstorageserverip' => options['pingstorageserverip'], 
            'tftpdir' => options['tftpdir'], 
            'password' => options['password']  
          )
          request(options)
        end
      end

    end
  end
end

