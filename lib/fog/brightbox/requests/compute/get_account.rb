module Fog
  module Compute
    class Brightbox
      class Real
        # Requests details about an account from the API
        #
        # === Parameters:
        #
        # <tt>identifier <String></tt>:: The identifier to request (Default is +nil+)
        #
        # === Returns:
        #
        # <tt>Hash</tt>:: The JSON response parsed to a Hash
        #
        # === Notes:
        #
        # This also supports a deprecated form where if an identifier is not
        # passed then the scoping account is returned instead. This should not
        # be used in new code. Use #get_scoped_account instead.
        #
        # === Reference:
        #
        # https://api.gb1.brightbox.com/1.0/#account_get_account
        #
        def get_account(identifier = nil)
          if identifier.nil? || identifier.empty?
            Fog::Logger.deprecation("get_account() without a parameter is deprecated, use get_scoped_account instead [light_black](#{caller.first})[/]")
            get_scoped_account
          else
            request("get", "/1.0/accounts/#{identifier}", [200])
          end
        end

      end
    end
  end
end
