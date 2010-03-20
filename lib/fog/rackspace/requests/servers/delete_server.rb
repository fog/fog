module Fog
  module Rackspace
    module Servers
      class Real

        # Delete an existing server
        #
        # ==== Parameters
        # * id<~Integer> - Id of server to delete
        #
        def delete_server(server_id)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path   => "servers/#{server_id}"
          )
        end

      end

      class Mock

        def delete_server(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].detect { |server| server['id'] == server_id }
            if server['status'] == 'BUILD'
              response.status = 409
              raise(Excon::Errors.status_error({:expects => 202}, response))
            else
              @data[:last_modified][:servers].delete(server_id)
              @data[:servers].delete(server_id)
              response.status = 202
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 202}, response))
          end
          response
        end

      end
    end
  end
end
