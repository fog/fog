module Fog
  module Compute
    class GoGrid
      class Real

        # Start, Stop or Restart a server
        #
        # ==== Parameters
        # * 'server'<~String> - id or name of server to power
        # * 'power'<~String>  - power operation, in ['restart', 'start', 'stop']
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def grid_server_power(server, power)
          request(
            :path     => 'grid/server/power',
            :query    => {'server' => server, 'power' => power}
          )
        end

      end
    end
  end
end
