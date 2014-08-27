module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes vpn user
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeVpnUser.html]
        def remove_vpn_user(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeVpnUser') 
          else
            options.merge!('command' => 'removeVpnUser', 
            'username' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

