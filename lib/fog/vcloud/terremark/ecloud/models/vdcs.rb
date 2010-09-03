module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          def vdcs(options = {})
            @vdcs ||= Fog::Vcloud::Terremark::Ecloud::Vdcs.new(options.merge(:connection => self))
          end
        end

        #FIXME: Should be no need to do this ... duplicte code ... find a better way
        module Mock
          def vdcs(options = {})
            @vdcs ||= Fog::Vcloud::Terremark::Ecloud::Vdcs.new(options.merge(:connection => self))
          end
        end
        #/FIXME

        class Vdcs < Fog::Vcloud::Vdcs

          undef_method :create

          model Fog::Vcloud::Terremark::Ecloud::Vdc

        end
      end
    end
  end
end
