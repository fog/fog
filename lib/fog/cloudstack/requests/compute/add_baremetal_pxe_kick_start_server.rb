module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalPxeKickStartServer.html]
        def add_baremetal_pxe_kick_start_server(options={})
          options.merge!(
            'command' => 'addBaremetalPxeKickStartServer', 
            'url' => options['url'], 
            'tftpdir' => options['tftpdir'], 
            'username' => options['username'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'password' => options['password'], 
            'pxeservertype' => options['pxeservertype']  
          )
          request(options)
        end
      end

    end
  end
end

