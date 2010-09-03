module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :delete_vapp, 202, "DELETE"
        end

        module Mock
          def delete_vapp(vapp_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end

