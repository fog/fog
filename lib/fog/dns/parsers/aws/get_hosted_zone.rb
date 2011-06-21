module Fog
  module Parsers
    module DNS
      module AWS

        class GetHostedZone < Fog::Parsers::Base

          def reset
            @hosted_zone = {}
            @name_servers = []
            @response = {}
            @section = :hosted_zone
          end

          def end_element(name)
            if @section == :hosted_zone
              case name
              when 'Id'
                @hosted_zone[name]= value.sub('/hostedzone/', '')
              when 'Name', 'CallerReference', 'Comment'
                @hosted_zone[name]= value
              when 'HostedZone'
                @response['HostedZone'] = @hosted_zone
                @hosted_zone = {}
                @section = :name_servers
              end
            elsif @section == :name_servers
              case name
              when 'NameServer'
                @name_servers << value
              when 'NameServers'
                @response['NameServers'] = @name_servers
                @name_servers = {}
              end
            end
          end

        end

      end
    end
  end
end
