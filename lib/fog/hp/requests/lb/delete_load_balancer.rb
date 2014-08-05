module Fog
  module HP
      class LB
        # Delete an existing load balancer
        #
        # ==== Parameters
        # * 'load_balancer_id'<~String> - UUId of load balancer to delete
        #
        class Real
          def delete_load_balancer(load_balancer_id)
            request(
                :expects => 202,
                :method  => 'DELETE',
                :path    => "loadbalancers/#{load_balancer_id}"
            )
          end
        end

        class Mock
          def delete_load_balancer(load_balancer_id)
            response = Excon::Response.new
            if list_load_balancers.body['loadBalancers'].find { |_| _['id'] == load_balancer_id }
              response.status = 202
              response
            else
              raise Fog::HP::LB::NotFound
            end
          end
        end
      end
  end
end
