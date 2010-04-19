module Fog
  module Parsers
    module Terremark

      class PublicIp < Fog::Parsers::Base

        def reset
          @response = {}
        end

        def end_element(name)
          case name
          when 'Href', 'Name'
            @response[name] = @value
          when 'Id'
            @response[name] = @value.to_i
          end
        end

      end

    end
  end
end
