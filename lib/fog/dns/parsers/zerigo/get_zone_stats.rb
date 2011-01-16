module Fog
  module Parsers
    module Zerigo
      module DNS

        class GetZoneStats < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'id', 'queries'
              @response[name] = @value.to_i
            when 'domain', 'period-begin', 'period-end'
              @response[name] = @value
            end            
          end

        end

      end
    end
  end
end
