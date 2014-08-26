module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroys a l2tp/ipsec remote access vpn
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteRemoteAccessVpn.html]
        def delete_remote_access_vpn(publicipid, options={})
          options.merge!(
            'command' => 'deleteRemoteAccessVpn', 
            'publicipid' => publicipid  
          )
          request(options)
        end
      end

    end
  end
end

