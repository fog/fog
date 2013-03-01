module Fog
  module HP
    class BlockStorage
      class LB
        class Real
          def list_algorithms
            response = request(
                :expects => 200,
                :method  => 'GET',
                :path    => 'algorithms'
            )
            response
          end
        end
        class Mock
          def list_algorithms
            response = Excon::Response.new

            response

          end
        end
      end
    end
  end
end