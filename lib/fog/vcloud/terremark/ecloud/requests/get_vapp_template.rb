module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_vapp_template
        end

        module Mock
          def get_vapp_template(templace_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
