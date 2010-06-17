module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :power_off, 202, 'POST'
        end

        module Mock
          def power_off(off_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
