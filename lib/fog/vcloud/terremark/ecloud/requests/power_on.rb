module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :power_on, 202, 'POST'
        end

        class Mock
          def power_on(on_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
