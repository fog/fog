module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates a user account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/updateUser.html]
        def update_user(options={})
          options.merge!(
            'command' => 'updateUser'
          )

          request(options)
        end

      end
    end
  end
end
