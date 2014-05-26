module Fog
  module Storage
    class IBM
      class Real
        # Returns the offerings of storage for the authenticated user
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'volumes'<~Array>: list of images
        #       * 'name'<~String>: Name of storage offering
        #       * 'price'<~Hash>: hash containing pricing information
        #         * 'pricePerQuantity'<~Integer>:
        #         * 'effectiveDate'<~Integer>: starting date price is effective
        #         * 'rate'<~Float>: rate per unit
        #         * 'countryCode'<~String>:
        #         * 'currencyCode'<~String>: currency used
        #       * 'location'<~String>: datacenter location string
        #       * 'id'<~String>: id of offering
        #       * 'formats'<~Array>: filesystem format storage offered with
        #         * 'label'<~String>: label for filesystem
        #         * 'id'<~String>: string used for id of format
        #       * 'capacity'<~Integer>: size in GB's
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
