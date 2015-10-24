module Fog
  module Compute
    class Linode
      class Real
        # Get NodeBalancer pricing information.
        #
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #       * 'MONTHLY'<~Float>        - Monthly price
        #       * 'HOURLY'<~Float>:        - Hourly price
        #       * 'CONNECTIONS'<~Integer>: - Maximum concurrent connections
        def avail_nodebalancers
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.nodebalancers' }
          )
        end
      end

      class Mock
        def avail_nodebalancers
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION" => "avail.nodebalancers",
            "DATA" => [{
              "MONTHLY" => 20.0,
              "HOURLY" => 0.03,
              "CONNECTIONS" => 10000
            }]
          }
          response
        end
      end
    end
  end
end
