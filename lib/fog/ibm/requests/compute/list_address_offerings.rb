module Fog
  module Compute
    class IBM
      class Real

        # Returns the offerings of static address types/pricing for the authenticated user
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'addresses'<~Array>: list of address offerings
        #       * 'price'<~Hash>: pricing info for specific address offering
        #       * 'price'<~Hash>: hash containing pricing information
        #         * 'pricePerQuantity'<~Integer>:
        #         * 'effectiveDate'<~Integer>: starting date price is effective
        #         * 'rate'<~Float>: rate per unit
        #         * 'countryCode'<~String>:
        #         * 'unitOfMeasure'<~String>:
        #         * 'currencyCode'<~String>: currency used
        #       * 'location'<~String>: datacenter location string
        #       * 'ipType'<~Integer>: type of ip address
        #       * 'id'<~String>: id of offering
        def list_address_offerings
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => '/offerings/address'
          )
        end

      end

      class Mock

        def list_address_offerings
          response = Excon::Response.new
          response.status = 200
          response.body = {"addresses"=>
              [{"price"=>
                 {"pricePerQuantity"=>1,
                  "effectiveDate"=>1302566400000,
                  "rate"=>0.01,
                  "countryCode"=>"897",
                  "unitOfMeasure"=>"UHR",
                  "currencyCode"=>"USD"},
                "location"=>"101",
                "ipType"=>0,
                "id"=>"20001223"}]}
          response
        end

      end
    end
  end
end
