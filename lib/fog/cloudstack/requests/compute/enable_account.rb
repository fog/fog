module Fog
  module Compute
    class Cloudstack
      class Real

        # Enables an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/enableAccount.html]
        def enable_account(options={})
          options.merge!(
            'command' => 'enableAccount'
          )

          request(options)
        end

      end
    end
  end
end
