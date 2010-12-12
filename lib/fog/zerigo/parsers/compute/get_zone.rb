require 'date'

module Fog
  module Parsers
    module Zerigo
      module Compute

        class GetZone < Fog::Parsers::Base

          def reset
            @host = {}
            @hosts = {}
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
              when 'id', 'priority', 'ttl'
                @host[name] = @value.to_i
              when 'data', 'fgdn', 'host-type', 'hostname', 'notes', 'zone-id', 'created-at type', 'updated-at'
                @host[name] = @value
              when 'host'
                @hosts << @host
                @host = {}
              when 'hosts'
                @response[name] << @hosts
                @in_hosts = false
              end
            else
              #in zone part of data
              case name
              when 'default-ttl', 'id', 'nx-ttl'
                @response[name] = @value.to_i
              when 'created-at', 'updated-at', 'domain', 'hostmaster', 'custom-nameservers', 'slave-nameservers', 'custom-ns', 'ns-type', 'ns1', 'notes'
                @response[name] = @value
              end
            end
            
          end

        end

      end
    end
  end
end
