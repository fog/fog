module Fog
  module Parsers
    module DNS
      module Bluebox

        class GetZone < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'serial', 'ttl', 'retry', 'expires', 'record-count', 'refresh', 'minimum'
              @response[name] = value.to_i
            when 'name', 'id'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
