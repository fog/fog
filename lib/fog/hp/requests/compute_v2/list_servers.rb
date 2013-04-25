module Fog
  module Compute
    class HPV2
      class Real

        # List all servers (IDs and names only)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Array>:
        #     * 'id'<~Integer> - UUId of server
        #     * 'name'<~String> - Name of server
        #     * 'links'<~Array> - array of server links
        def list_servers
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'servers'
          )
        end

      end

      class Mock

        def list_servers
          response = Excon::Response.new
          data = list_servers_detail.body['servers']
          servers = []
          for server in data
            servers << server.reject { |key, value| !['id', 'name', 'links', 'uuid'].include?(key) }
          end
          response.status = 200
          response.body = { 'servers' => servers }
          response
        end

      end
    end
  end
end
