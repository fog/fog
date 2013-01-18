module Fog
  module Compute
    class Cloudstack
      class Real

        # Disables a user account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/disableUser.html]
        def disable_user(options={})
          options.merge!(
            'command' => 'disableUser'
          )

          request(options)
        end

      end
    end
  end
end
