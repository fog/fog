module Fog
  class Vcloud
    module Terremark
      class Vcloud < Fog::Vcloud
        request_path 'fog/vcloud/terremark/vcloud/requests'
        request :get_vdc

        class Real < Fog::Vcloud::Real

          def initialize(options = {})
            location = caller.first
            warning = "[yellow][WARN] Fog::Vcloud::Terremark::Vcloud is deprecated, to be replaced with Vcloud 1.0 someday/maybe[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            super
          end

          def supporting_versions
            ["0.8", "0.8a-ext1.6"]
          end

        end

        class Mock < Fog::Vcloud::Mock

          def initialize(options = {})
            location = caller.first
            warning = "[yellow][WARN] Fog::Vcloud::Terremark::Vcloud is deprecated, to be replaced with Vcloud 1.0 someday/maybe[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            super
          end

        end

      end
    end
  end
end
