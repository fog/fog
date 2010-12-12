module Fog
  module Parsers
    module Zerigo
      module Compute

        class CountZones < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'count'
              @response[name] = @value.to_i
            end
          end

        end

      end
    end
  end
end
