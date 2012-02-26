module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a account, and all users associated with this account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteAccount.html]
        def delete_account(options={})
          options.merge!(
            'command' => 'deleteAccount'
          )

          request(options)
        end

      end
    end
  end
end
