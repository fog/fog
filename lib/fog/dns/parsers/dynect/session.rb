module Fog
  module Parsers
    module Dynect
      module DNS

        class Session < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'token'
              @response['API-Token'] = @value
            when 'version'
              @response['API-Version'] = @value
            end
          end

        end
      end
    end
  end
end
