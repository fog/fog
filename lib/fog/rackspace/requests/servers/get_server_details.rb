unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Get details about a server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'server'<~Hash>:
        #     * 'addresses'<~Hash>:
        #       * 'public'<~Array> - public address strings
        #       * 'private'<~Array> - private address strings
        #     * 'flavorId'<~Integer> - Id of servers current flavor
        #     * 'hostId'<~String>
        #     * 'id'<~Integer> - Id of server
        #     * 'imageId'<~Integer> - Id of image used to boot server
        #     * 'metadata'<~Hash> - metadata
        #     * 'name<~String> - Name of server
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'status'<~String> - Current server status
        def get_server_details(server_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def get_server_details(server_id)
          response = Fog::Response.new
          if server = list_servers_detail.body['servers'].detect { |server| server['id'] == server_id }
            response.status = [200, 203][rand(1)]
            response.body = { 'server' => server }
          else
            response.status = 404
            raise(Excon::Errors.status_error(202, 404, response))
          end
          response
        end

      end
    end
  end

end
