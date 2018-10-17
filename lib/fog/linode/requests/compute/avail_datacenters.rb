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
              { "LOCATION" => "Dallas, TX, USA",     "DATACENTERID" => 2,  "ABBR" => "dallas" },
              { "LOCATION" => "Fremont, CA, USA",    "DATACENTERID" => 3,  "ABBR" => "fremont" },
              { "LOCATION" => "Atlanta, GA, USA",    "DATACENTERID" => 4,  "ABBR" => "atlanta" },
              { "LOCATION" => "Newark, NJ, USA",     "DATACENTERID" => 6,  "ABBR" => "newark" },
              { "LOCATION" => "London, England, UK", "DATACENTERID" => 7,  "ABBR" => "london" },
              { "LOCATION" => "Tokyo, JP",           "DATACENTERID" => 8,  "ABBR" => "tokyo" },
              { "LOCATION" => "Singapore, SGP",      "DATACENTERID" => 9,  "ABBR" => "singapore" },
              { "LOCATION" => "Frankfurt, DE",       "DATACENTERID" => 10, "ABBR" => "frankfurt" },
              { "LOCATION" => "Tokyo 2, JP",         "DATACENTERID" => 11, "ABBR" => "tokyo2" },
            ],
            "ACTION" => "avail.datacenters"
          }
          response
        end
      end
    end
  end
end
