module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds vpn users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addVpnUser.html]
        def add_vpn_user(options={})
          options.merge!(
            'command' => 'addVpnUser', 
            'username' => options['username'], 
            'password' => options['password']  
          )
          request(options)
        end
      end

    end
  end
end

