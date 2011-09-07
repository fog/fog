module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createAccount.html]
        def create_account(options={})
          options.merge!(
            'command' => 'createAccount'
          )

          request(options)
        end

      end
    end
  end
end
