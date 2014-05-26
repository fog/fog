module Fog
  module Parsers
    module DNS
      module Zerigo
        class ListZones < Fog::Parsers::Base
          def reset
            @zone = {}
            @response = { 'zones' => [] }
          end

          def end_element(name)
            case name
            when 'default-ttl', 'id', 'nx-ttl', 'hosts-count'
              @zone[name] = value.to_i
            when 'created-at', 'custom-nameservers', 'custom-ns', 'domain', 'hostmaster', 'notes', 'ns1', 'ns-type', 'slave-nameservers', 'tag-list', 'updated-at', 'hosts', 'axfr-ips', 'restrict-axfr'
              @zone[name] = value
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
