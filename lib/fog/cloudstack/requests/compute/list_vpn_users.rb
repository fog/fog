module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists vpn users
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVpnUsers.html]
        def list_vpn_users(options={})
          options.merge!(
            'command' => 'listVpnUsers'  
          )
          request(options)
        end
      end

    end
  end
end

