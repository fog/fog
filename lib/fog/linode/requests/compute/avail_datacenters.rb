module Fog
  module Compute
    class Linode
      class Real
        # Get available data centers
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def avail_datacenters
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.datacenters' }
          )
        end
      end

      class Mock
        def avail_datacenters
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "DATA" => [
              { "LOCATION" => "Dallas, TX, USA",     "DATACENTERID" => 2 },
              { "LOCATION" => "Fremont, CA, USA",    "DATACENTERID" => 3 },
              { "LOCATION" => "Atlanta, GA, USA",    "DATACENTERID" => 4 },
              { "LOCATION" => "Newark, NJ, USA",     "DATACENTERID" => 6 },
              { "LOCATION" => "London, England, UK", "DATACENTERID" => 7 },
              { "LOCATION" => "Tokyo, JP",           "DATACENTERID" => 8 }
            ],
            "ACTION" => "avail.datacenters"
          }
          response
        end
      end
    end
  end
end
