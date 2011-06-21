module Fog
  module Parsers
    module DNS
      module Zerigo

        class FindHosts < Fog::Parsers::Base

          def reset
            @host = {}
            @response = { 'hosts' => [] }
          end

          def end_element(name)
            case name
            when 'id', 'priority', 'ttl', 'zone-id'
              @host[name] = value.to_i
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
