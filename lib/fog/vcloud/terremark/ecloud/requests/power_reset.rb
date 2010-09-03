module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :power_reset, 202, 'POST'
        end

        module Mock
          def power_reset(reset_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
