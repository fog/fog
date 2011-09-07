module Fog
  module Compute
    class Cloudstack
      class Real

        # Enables a user account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/registerUserKeys.html]
        def register_user_keys(options={})
          options.merge!(
            'command' => 'registerUserKeys'
          )

          request(options)
        end

      end
    end
  end
end
