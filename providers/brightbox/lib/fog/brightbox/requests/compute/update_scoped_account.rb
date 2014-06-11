module Fog
  module Compute
    class Brightbox
      class Real
        # Requests an update to the currently scoped account
        #
        # @param [Hash] options
        # @option options [String] :name Account name
        # @option options [String] :address_1 First line of address
        # @option options [String] :address_2 Second line of address
        # @option options [String] :city City part of address
        # @option options [String] :county County part of address
        # @option options [String] :postcode Postcode or Zipcode
        # @option options [String] :country_code ISO 3166-1 two letter code (example: `GB`)
        # @option options [String] :vat_registration_number Must be a valid EU VAT number or `nil`
        # @option options [String] :telephone_number Valid International telephone number in E.164 format prefixed with `+`
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_update_account
        #
        def update_scoped_account(options)
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/account", [200], options)
        end
      end
    end
  end
end
