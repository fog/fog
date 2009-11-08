unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Delete an existing server
        #
        # ==== Parameters
        # * id<~Integer> - Id of server to delete
        #
        def delete_server(id)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path   => "servers/#{id}"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def delete_server(id)
          response = Fog::Response.new
          if server = Fog::Rackspace::Servers.data[:servers][id]
            if server['STATUS'] == 'BUILD'
              response.status = 409
              raise(Excon::Errors.status_error(200, 400, response))
            else
              Fog::Rackspace::Servers.delete(id)
              response.status = 202
            end
          else
            response.status = 404
          end
          response
        end

      end
    end
  end

end
