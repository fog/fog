module Fog
  module Vcloud
    class Compute
      module Helpers
        module Status
          def friendly_status
            load_unless_loaded!
            case status
              when '0'
            'creating'
              when '8'
            'off'
              when '4'
            'on'
            else
            'unknown'
            end
          end

          def on?
            reload_status
            status == '4'
          end

          def off?
            reload_status
            status == '8'
          end

          def reload_status
            reload # always ensure we have the correct status
          end
        end
      end
    end
  end
end
