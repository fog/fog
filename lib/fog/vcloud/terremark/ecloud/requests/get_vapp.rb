module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_vapp
        end

        module Mock
          def get_vapp(vapp_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
