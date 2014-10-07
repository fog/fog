module Fog
  module Parsers
    module DNS
      module Zerigo
        class CreateZone < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'default-ttl', 'id', 'nx-ttl', 'hosts-count'
              @response[name] = value.to_i
            when 'created-at', 'custom-nameservers', 'custom-ns', 'domain', 'hostmaster', 'notes', 'ns1', 'ns-type', 'slave-nameservers', 'tag-list', 'updated-at', 'hosts', 'axfr-ips', 'restrict-axfr'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
