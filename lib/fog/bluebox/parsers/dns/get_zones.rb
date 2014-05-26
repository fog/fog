module Fog
  module Parsers
    module DNS
      module Bluebox
        class GetZones < Fog::Parsers::Base
          def reset
            @zone = {}
            @response = { 'zones' => [] }
          end

          def end_element(name)
            case name
            when 'serial', 'ttl', 'retry', 'expires', 'record-count', 'refresh', 'minimum'
              @zone[name] = value.to_i
            when 'name', 'id'
              @zone[name] = value
            when 'record'
              @response['zones'] << @zone
              @zone = {}
            end
          end
        end
      end
    end
  end
end
