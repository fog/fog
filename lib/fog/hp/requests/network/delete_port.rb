module Fog
  module HP
    class Network
      class Real
        # Delete an existing port
        #
        # ==== Parameters
        # * port_id<~String> - UUId for the port to delete
        def delete_port(port_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "ports/#{port_id}"
          )
        end
      end

      class Mock
        def delete_port(port_id)
          response = Excon::Response.new
          if list_ports.body['ports'].find {|_| _['id'] == port_id}
            self.data[:ports].delete(port_id)
            response.status = 204
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
