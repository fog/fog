module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :power_on, 202, 'POST'
        end

        module Mock
          def power_on(on_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
