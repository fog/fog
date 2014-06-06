module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes vpn user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeVpnUser.html]
        def remove_vpn_user(username, options={})
          options.merge!(
            'command' => 'removeVpnUser', 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

