module Fog
  module Compute
    class Cloudstack
      class Real

        # Disables an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/disableAccount.html]
        def disable_account(options={})
          options.merge!(
            'command' => 'disableAccount'
          )

          request(options)
        end

      end
    end
  end
end
