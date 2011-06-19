module Fog
  module Parsers
    module Dynect
      module DNS

        class NodeList < Fog::Parsers::Base

          def reset
            @response = []
          end

          def end_element(name)
            case name
            when 'item'
              @response << @value unless @value == "INFO"
            end
          end

        end
      end
    end
  end
end
