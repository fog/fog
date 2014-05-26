module Fog
  module Parsers
    module DNS
      module Zerigo
        class ListHosts < Fog::Parsers::Base
          def reset
            @host = {}
            @response = { 'hosts' => [] }
          end

          def end_element(name)
            case name
            when 'id', 'zone-id'
              @host[name] = value.to_i
            when 'priority', 'ttl'
              @host[name] = value.to_i if value
            when 'data', 'fqdn', 'host-type', 'hostname', 'notes', 'zone-id', 'created-at', 'updated-at'
              @host[name] = value
            when 'host'
              @response['hosts'] << @host
              @host = {}
            end
          end
        end
      end
    end
  end
end
