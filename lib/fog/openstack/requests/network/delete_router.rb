module Fog
  module Network
    class OpenStack

      class Real
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
          if list_routers.body['routers'].map { |r| r['id'] }.include? router_id
            self.data[:routers].delete(router_id)
            response.status = 204
            response
          else
            raise Fog::Network::OpenStack::NotFound
          end
        end
      end

    end
  end
end
