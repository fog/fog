module Fog
  module Parsers
    module Dynect
      module DNS

        class Zone < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'zone', 'zone_type', 'serial_style'
              @response[name] = @value
            when 'serial'
              @response['serial'] = @value.to_i
            end
          end

        end
      end
    end
  end
end
