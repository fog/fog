module Fog
  module HP
    class Network
      class Real
        # Delete an existing network
        #
        # ==== Parameters
        # * 'network_id'<~String> - UUId for the network to delete
        def delete_network(network_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "networks/#{network_id}"
          )
        end
      end

      class Mock
        def delete_network(network_id)
          response = Excon::Response.new
          if list_networks.body['networks'].find {|_| _['id'] == network_id}
            self.data[:networks].delete(network_id)
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
