module Fog
  module HP
    class BlockStorage
      class LB
        class Real
          def create_load_balancer_node(load_balancer_id,options={})

          end
        end
        class Mock
          def create_load_balancer_node(load_balancer_id, options={})
            response = Excon::Response.new


            response

          end
        end
      end
    end
  end
end