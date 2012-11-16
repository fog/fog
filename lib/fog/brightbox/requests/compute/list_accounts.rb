module Fog
  module Compute
    class Brightbox
      class Real
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_list_accounts
        #
        def list_accounts
          request("get", "/1.0/accounts", [200])
        end

      end
    end
  end
end
