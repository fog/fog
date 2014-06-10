module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the account.
        #
        # @overload get_account(identifier)
        #   @param [String] identifier Unique reference to identify the resource
        #
        # @overload get_account()
        #   @deprecated Use {Fog::Compute::Brightbox::Real#get_scoped_account} instead
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_get_account
        #
        def get_account(identifier = nil)
          if identifier.nil? || identifier.empty?
            Fog::Logger.deprecation("get_account() without a parameter is deprecated, use get_scoped_account instead [light_black](#{caller.first})[/]")
            get_scoped_account
          else
            wrapped_request("get", "/1.0/accounts/#{identifier}", [200])
          end
        end
      end
    end
  end
end
