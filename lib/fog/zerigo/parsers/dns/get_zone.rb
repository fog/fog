module Fog
  module Parsers
    module DNS
      module Zerigo
        class GetZone < Fog::Parsers::Base
          def reset
            @host = {}
            @hosts = []
            @response = {}
            @in_hosts = false
          end

          def start_element(name, attrs = [])
            super(name, attrs)
            #look out for start of <hosts> section
            #needed as some of the tags have the same name as the parent <zone> section
            if name == 'hosts'
              @in_hosts= true
            end
          end

          def end_element(name)
            if (@in_hosts)
              #in hosts part of response
              case name
              when 'id', 'zone-id'
                @host[name] = value.to_i
              when 'priority', 'ttl'
                @host[name] = value.to_i if value
              when 'data', 'fqdn', 'host-type', 'hostname', 'notes', 'zone-id', 'created-at', 'updated-at'
                @host[name] = value
              when 'host'
                @hosts << @host
                @host = {}
              when 'hosts'
                @response[name] = @hosts
                @in_hosts = false
              end
            else
              #in zone part of data
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
end
