module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_customization_options
        end

        class Mock
          def get_customization_options( options_uri )
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
