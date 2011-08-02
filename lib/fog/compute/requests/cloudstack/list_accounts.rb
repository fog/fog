module Fog
  module Compute
    class Cloudstack
      class Real

        def list_accounts(options={})
          options.merge!(
            'command' => 'listAccounts'
          )
          
          request(options)
        end

      end
    end
  end
end
