unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Update an existing server
        #
        # ==== Parameters
        # # server_id<~Integer> - Id of server to update
        # * options<~Hash>:
        #   * adminPass<~String> - New admin password for server
        #   * name<~String> - New name for server
        def update_server(server_id, options = {})
          request(
            :body     => { 'server' => options }.to_json,
            :expects  => 204,
            :method   => 'PUT',
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

        def update_server(server_id, options)
          response = Fog::Response.new
          if server = list_servers_detail.body['servers'].detect { |server| server['id'] == server_id }
            if options['adminPass']
              server['adminPass'] = options['adminPass']
            end
            if options['name']
              server['name'] = options['name']
            end
            response.status = 204
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
