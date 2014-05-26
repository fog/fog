module Fog
  module HP
    class Network
      class Real
        # Delete an existing subnet
        #
        # ==== Parameters
        # * subnet_id<~String> - UUId for the subnet to delete
        def delete_subnet(subnet_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "subnets/#{subnet_id}"
          )
        end
      end

      class Mock
        def delete_subnet(subnet_id)
          response = Excon::Response.new
          if list_subnets.body['subnets'].find {|_| _['id'] == subnet_id}
            self.data[:subnets].delete(subnet_id)
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
