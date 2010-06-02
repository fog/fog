module Fog
  module Parsers
    module Bluebox

      class GetFlavor < Fog::Parsers::Base

        def reset
          @response = {}
        end

        def end_element(name)
          case name
          when 'cost'
            @response[name] = @value.to_f
          when 'description', 'id'
            @response[name] = @value
          end
        end

      end

    end
  end
end
