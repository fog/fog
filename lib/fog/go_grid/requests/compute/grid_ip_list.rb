module Fog
  module Compute
    class GoGrid
      class Real

        # List ips
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'datacenter'<~String> - datacenter to limit results to
        #   * 'ip.state'<~String>      - state to limit results to in ip.state
        #   * 'ip.type'<~String>       - type to limit results to in ip.type
        #   * 'num_items'<~Integer> - Number of items to return
        #   * 'page'<~Integer>      - Page index for paginated results
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def grid_ip_list(options={})
          request(
            :path     => 'grid/ip/list',
            :query    => options
          )
        end

      end
    end
  end
end
