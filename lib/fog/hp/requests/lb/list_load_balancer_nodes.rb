module Fog
  module HP
    class BlockStorage
      class LB
        class Real
          def list_load_balancer_nodes(load_balancer_id)
            response = request(
                :expects => 200,
                :method  => 'GET',
                :path    => 'loadbalancers/#{load_balancer_id}/nodes'
            )
            response
          end
        end
        class Mock
          def list_load_balancer_nodes(load_balancer_id)
            response = Excon::Response.new

            response

          end
        end
      end
    end
  end
end