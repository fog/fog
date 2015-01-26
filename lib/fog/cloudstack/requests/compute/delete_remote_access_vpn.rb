module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroys a l2tp/ipsec remote access vpn
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteRemoteAccessVpn.html]
        def delete_remote_access_vpn(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteRemoteAccessVpn') 
          else
            options.merge!('command' => 'deleteRemoteAccessVpn', 
            'publicipid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

