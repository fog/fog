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
            response = Excon::Response.new
            if image = find_load_balancer(instance_id)
              response.status = 202
            else
              raise Fog::HP::LB::NotFound
            end
            response
          end

          def find_load_balancer(record_id)
            list_load_balancers.body['loadBalancers'].detect { |_| _['id'] == record_id }
          end
        end
      end
  end
end