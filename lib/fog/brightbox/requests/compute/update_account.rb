module Fog
  module Compute
    class Brightbox
      class Real

        # Requests an update to the currently scoped account
        #
        # === Parameters:
        #
        # <tt>identifier <String></tt>:: The identifier to request (Default is +nil+)
        # <tt>options <Hash></tt>:: Hash of options for update
        #
        # === Options:
        #
        # <tt>name</tt>:: Account name
        # <tt>address_1</tt>:: First line of address
        # <tt>address_2</tt>:: Second line of address
        # <tt>city</tt>:: City part of address
        # <tt>county</tt>:: County part of address
        # <tt>postcode</tt>:: Postal code
        # <tt>country_code</tt>:: ISO 3166-1 two letter code (example: +GB+)
        # <tt>vat_registration_number</tt>:: Valid EU VAT Number or +nil+
        # <tt>telephone_number</tt>:: Valid International telephone number in E.164 format prefixed with ’+’
        #
        # === Returns:
        #
        # <tt>Hash</tt>:: The JSON response parsed to a Hash
        # <tt>nil</tt>:: If no options were passed to update
        #
        # === Notes:
        #
        # This also supports a deprecated form where if an identifier is not
        # passed then the scoping account is updated instead. This should not
        # be used in new code. Use #update_scoped_account instead.
        #
        # === Reference:
        #
        # https://api.gb1.brightbox.com/1.0/#account_update_account
        #
        def update_account(*args)
          if args.size == 2
            identifier = args[0]
            options = args[1]
          elsif args.size == 1
            options = args[0]
          else
            raise ArgumentError, "wrong number of arguments (0 for 2)"
          end

          return nil if options.empty? || options.nil?
          if identifier.nil? || identifier.empty?
            Fog::Logger.deprecation("update_account() without a parameter is deprecated, use update_scoped_account instead [light_black](#{caller.first})[/]")
            update_scoped_account(options)
          else
            request("put", "/1.0/account", [200], options)
          end
        end

      end
    end
  end
end
