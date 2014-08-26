module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates remote access vpn
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateRemoteAccessVpn.html]
        def update_remote_access_vpn(options={})
          request(options)
        end


        def update_remote_access_vpn(id, options={})
          options.merge!(
            'command' => 'updateRemoteAccessVpn', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

