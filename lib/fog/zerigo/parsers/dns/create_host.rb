module Fog
  module Parsers
    module DNS
      module Zerigo
        class CreateHost < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'id', 'zone-id'
              @response[name] = value.to_i
            when 'priority', 'ttl'
              @response[name] = value.to_i if value
            when 'data', 'fqdn', 'host-type', 'hostname', 'notes', 'zone-id', 'created-at', 'updated-at'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
