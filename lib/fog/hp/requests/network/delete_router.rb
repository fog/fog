module Fog
  module HP
    class Network
      class Real
        # Delete an existing router
        #
        # ==== Parameters
        # * 'router_id'<~String> - UUId for the router to delete
        def delete_router(router_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "routers/#{router_id}"
          )
        end
      end

      class Mock
        def delete_router(router_id)
          response = Excon::Response.new
          if list_routers.body['routers'].find {|_| _['id'] == router_id}
            self.data[:routers].delete(router_id)
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
