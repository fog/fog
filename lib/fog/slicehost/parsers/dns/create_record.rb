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
            when 'zone_id'
              @response["zone-id"] = value.to_i
            when 'record_type'
              @response["record-type"] = value
            when 'ttl', 'id'
              @response[name] = value.to_i
            when 'value'
              @response["data"] = value
            when 'name', 'data', 'active', 'aux'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
