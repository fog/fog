module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the account.
        #
        # @overload update_account(identifier, options)
        #   @param [String] identifier Unique reference to identify the resource
        #   @param [Hash] options
        #   @option options [String] :name Account name
        #   @option options [String] :address_1 First line of address
        #   @option options [String] :address_2 Second line of address
        #   @option options [String] :city City part of address
        #   @option options [String] :county County part of address
        #   @option options [String] :postcode Postcode or Zipcode
        #   @option options [String] :country_code ISO 3166-1 two letter code (example: `GB`)
        #   @option options [String] :vat_registration_number Must be a valid EU VAT number or `nil`
        #   @option options [String] :telephone_number Valid International telephone number in E.164 format prefixed with `+`
        #
        # @overload update_account(options)
        #   @deprecated Use {Fog::Compute::Brightbox::Real#update_scoped_account} instead
        #
        #   @param [Hash] options
        #   @option options [String] :name Account name
        #   @option options [String] :address_1 First line of address
        #   @option options [String] :address_2 Second line of address
        #   @option options [String] :city City part of address
        #   @option options [String] :county County part of address
        #   @option options [String] :postcode Postcode or Zipcode
        #   @option options [String] :country_code ISO 3166-1 two letter code (example: `GB`)
        #   @option options [String] :vat_registration_number Must be a valid EU VAT number or `nil`
        #   @option options [String] :telephone_number Valid International telephone number in E.164 format prefixed with `+`
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_update_account
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
            wrapped_request("put", "/1.0/accounts/#{identifier}", [200], options)
          end
        end

      end
    end
  end
end
