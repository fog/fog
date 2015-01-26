module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal ping pxe server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addBaremetalPxePingServer.html]
        def add_baremetal_pxe_ping_server(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addBaremetalPxePingServer') 
          else
            options.merge!('command' => 'addBaremetalPxePingServer', 
            'physicalnetworkid' => args[0], 
            'pxeservertype' => args[1], 
            'pingstorageserverip' => args[2], 
            'url' => args[3], 
            'tftpdir' => args[4], 
            'password' => args[5], 
            'pingdir' => args[6], 
            'username' => args[7])
          end
          request(options)
        end
      end

    end
  end
end

