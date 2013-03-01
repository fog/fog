module Fog
  module HP
    class BlockStorage
      class LB
        class Real
          def list_protocols
            response = request(
                :expects => 200,
                :method  => 'GET',
                :path    => 'protocols'
            )
            response
          end
        end
        class Mock
          def list_protocols
            response = Excon::Response.new

            response
          end
        end
      end
    end
  end
end