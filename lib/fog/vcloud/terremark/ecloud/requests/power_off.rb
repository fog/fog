module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :power_off, 202, 'POST'
        end

        class Mock
          def power_off(off_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
