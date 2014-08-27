module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists vpn users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVpnUsers.html]
        def list_vpn_users(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVpnUsers') 
          else
            options.merge!('command' => 'listVpnUsers')
          end
          request(options)
        end
      end

    end
  end
end

