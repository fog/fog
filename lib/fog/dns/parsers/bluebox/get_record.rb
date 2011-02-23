module Fog
  module Parsers
    module Bluebox
      module DNS

        class GetRecord < Fog::Parsers::Base

          def reset
            @response = { }
          end

          def end_element(name)
            @response[name] = @value
          end

        end

      end
    end
  end
end
