module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_vapp
        end

        class Mock
          def get_vapp(vapp_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
