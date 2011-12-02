module Fog
  module Compute
    class IBM
      class Real

        # Returns address offerings
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO: doc
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
