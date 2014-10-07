module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates remote access vpn
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateRemoteAccessVpn.html]
        def update_remote_access_vpn(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateRemoteAccessVpn') 
          else
            options.merge!('command' => 'updateRemoteAccessVpn', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

