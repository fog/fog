module Fog
  module Compute
    class GoGrid
      class Real
        # Get one or more servers by name
        #
        # ==== Parameters
        # * 'server'<~String> - id or name of server(s) to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def grid_server_get(servers)
          request(
            :path     => 'grid/server/get',
            :query    => {'server' => [*servers]}
          )
        end
      end
    end
  end
end
