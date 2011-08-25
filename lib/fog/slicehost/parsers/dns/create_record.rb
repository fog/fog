module Fog
  module Parsers
    module DNS
      module Slicehost

        class CreateRecord < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'zone-id', 'ttl', 'id'
              @response[name] = value.to_i
            when 'record-type', 'name', 'data', 'active', 'aux'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
