module Fog
  module Compute
    class Brightbox
      class Real

        # Requests an update to the currently scoped account
        #
        # === Parameters:
        #
        # <tt>options</tt>:: Hash of options for update
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
        def update_scoped_account(options)
          return nil if options.empty? || options.nil?
          request("put", "/1.0/account", [200], options)
        end

      end
    end
  end
end
