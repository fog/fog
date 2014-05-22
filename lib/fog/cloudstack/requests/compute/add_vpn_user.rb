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
            'password' => options['password'], 
            'username' => options['username'], 
             
          )
          request(options)
        end
      end

    end
  end
end

