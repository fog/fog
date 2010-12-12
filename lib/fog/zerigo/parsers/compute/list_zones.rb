module Fog
  module Parsers
    module Zerigo
      module Compute

        class ListZones < Fog::Parsers::Base

          def reset
            @zone = {}
            @response = { 'zones' => [] }
          end

          def end_element(name)
            case name
            when 'default-ttl', 'id', 'nx-ttl'
              @zone[name] = @value.to_i
            when 'created-at', 'updated-at', 'domain', 'hostmaster', 'custom-nameservers', 'slave-nameservers', 'custom-ns', 'ns-type', 'ns1', 'notes'
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
