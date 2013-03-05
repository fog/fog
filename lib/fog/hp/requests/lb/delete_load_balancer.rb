module Fog
  module HP
      class LB
        class Real

          def delete_load_balancer(instance_id)
            response = request(
                :expects => 202,
                :method  => 'DELETE',
                :path    => "loadbalancers/#{instance_id}"
            )
            response
          end

        end
        class Mock
          def delete_load_balancer(instance_id)

          end
        end
      end
  end
end