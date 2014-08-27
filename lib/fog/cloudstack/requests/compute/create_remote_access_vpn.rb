module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a l2tp/ipsec remote access vpn
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createRemoteAccessVpn.html]
        def create_remote_access_vpn(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createRemoteAccessVpn') 
          else
            options.merge!('command' => 'createRemoteAccessVpn', 
            'publicipid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

