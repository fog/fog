module Fog
  module Compute
    class Cloudstack
      class Real

        # Enables a user account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/enableUser.html]
        def enable_user(options={})
          options.merge!(
            'command' => 'enableUser'
          )

          request(options)
        end

      end
    end
  end
end
