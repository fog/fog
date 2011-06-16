module Fog
  module Compute
    class Ninefold
      class Real

        def list_accounts(options = {})
          request('listAccounts', options, :expects => [200],
                  :response_prefix => 'listaccountsresponse/account', :response_type => Array)
        end

      end
    end
  end
end
