module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Mock
          def vdcs(options = {})
            @vdcs ||= Fog::Vcloud::Terremark::Ecloud::Vdcs.new(options.merge(:connection => self))
          end
        end

        module Real
          def vdcs(options = {})
            @vdcs ||= Fog::Vcloud::Terremark::Ecloud::Vdcs.new(options.merge(:connection => self))
          end
        end

        class Vdcs < Fog::Vcloud::Vdcs

          undef_method :create

          model Fog::Vcloud::Terremark::Ecloud::Vdc

          #get_request :get_vdc
          #vcloud_type "application/vnd.vmware.vcloud.vdc+xml"
          #all_request lambda { |vdcs| vdcs.connection.get_organization(vdcs.organization_uri) }

        end
      end
    end
  end
end
