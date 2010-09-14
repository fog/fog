module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :delete_vapp, 202, "DELETE"
        end

        class Mock
          def delete_vapp(vapp_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end

