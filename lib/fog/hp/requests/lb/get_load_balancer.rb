module Fog
  module HP
    class BlockStorage
      class LB
        class Real
          def get_load_balancer(load_balancer_id)
            response = request(
                :expects => 200,
                :method  => 'GET',
                :path    => "loadbalancers/#{load_balancer_id}"
            )
            response
          end

        end
        class Mock
          def get_load_balancer(load_balancer_id)

          end
        end
      end
    end
  end
end