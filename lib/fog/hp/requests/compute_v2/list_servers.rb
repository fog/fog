module Fog
  module Compute
    class HPV2
      class Real
        # List all servers (IDs and names only)
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'name'<~String> - Filters by the name of the server
        #   * 'image'<~String> - Filters by the UUId of the image
        #   * 'flavor'<~String> - Filters by the UUId of the flavor
        #   * 'status'<~String> - Filters by the status of the server
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #   * 'changes-since'<~DateTime> - Filters by the changes-since time. The list contains servers that have been deleted since the changes-since time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Array>:
        #     * 'id'<~Integer> - UUId of server
        #     * 'name'<~String> - Name of server
        #     * 'links'<~Array> - array of server links
        def list_servers(options = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'servers',
            :query    => options
          )
        end
      end

      class Mock
        def list_servers(options = {})
          response = Excon::Response.new
          data = list_servers_detail.body['servers']
          servers = []
          for server in data
            servers << server.reject { |key, value| !['id', 'name', 'links'].include?(key) }
          end
          response.status = 200
          response.body = { 'servers' => servers }
          response
        end
      end
    end
  end
end
