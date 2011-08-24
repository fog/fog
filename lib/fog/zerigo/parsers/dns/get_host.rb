module Fog
  module Parsers
    module DNS
      module Zerigo

        class GetHost < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'id', 'priority', 'ttl', 'zone-id'
              @response[name] = value.to_i
            when 'data', 'fqdn', 'host-type', 'hostname', 'notes', 'zone-id', 'created-at', 'updated-at'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
