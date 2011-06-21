module Fog
  module Parsers
    module DNS
      module Slicehost

        class GetZone < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'ttl', 'id'
              @response[name] = value.to_i
            when 'origin', 'active'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
