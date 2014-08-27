module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds vpn users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addVpnUser.html]
        def add_vpn_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addVpnUser') 
          else
            options.merge!('command' => 'addVpnUser', 
            'password' => args[0], 
            'username' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

