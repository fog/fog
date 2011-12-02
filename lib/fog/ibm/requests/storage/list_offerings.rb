module Fog
  module Storage
    class IBM
      class Real

        # Get available storage offerings
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volumes<~Array>
        # TODO: docs
        def list_offerings
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/storage'
          )
        end

      end

      class Mock

        def list_offerings
          response = Excon::Response.new
          response.status = 200
          response.body = {"volumes"=>
              [{"name"=>"Small",
                "price"=>
                 {"pricePerQuantity"=>1,
                  "effectiveDate"=>-1,
                  "rate"=>0.0384,
                  "countryCode"=>"897",
                  "unitOfMeasure"=>"UHR",
                  "currencyCode"=>"USD"},
                "location"=>"61",
                "id"=>"20001208",
                "formats"=>
                 [{"label"=>"ext3", "id"=>"EXT3"}, {"label"=>"raw", "id"=>"RAW"}],
                "capacity"=>256},
               {"name"=>"Small",
                "price"=>
                 {"pricePerQuantity"=>1,
                  "effectiveDate"=>-1,
                  "rate"=>0.0384,
                  "countryCode"=>"897",
                  "unitOfMeasure"=>"UHR",
                  "currencyCode"=>"USD"},
                "location"=>"141",
                "id"=>"20001208",
                "formats"=>
                 [{"label"=>"ext3", "id"=>"EXT3"}, {"label"=>"raw", "id"=>"RAW"}],
                "capacity"=>256}]},
          response
        end

      end
    end
  end
end
