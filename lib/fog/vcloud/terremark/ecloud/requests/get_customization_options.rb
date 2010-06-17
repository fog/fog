module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_customization_options
        end

        module Mock
          def get_customization_options( options_uri )
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
