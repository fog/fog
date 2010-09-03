module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :power_shutdown, 204, 'POST'
        end

        module Mock
          def power_shutdown(shutdown_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
