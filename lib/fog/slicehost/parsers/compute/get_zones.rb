module Fog
  module Parsers
    module Slicehost
      module Compute

        class GetZones < Fog::Parsers::Base

          def reset
            @zone = {}
            @response = { 'zones' => [] }
          end

          def end_element(name)
            case name
            when 'ttl', 'id'
              @zone[name] = @value.to_i
            when 'active', 'origin'
              @zone[name] = @value
            when 'zone'
              @response['zones'] << @zone
              @zone = {}
            end
          end

        end

      end
    end
  end
end
