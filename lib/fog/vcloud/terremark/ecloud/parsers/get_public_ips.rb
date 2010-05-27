module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Ecloud

          class GetPublicIps < Fog::Parsers::Vcloud::Base

            def reset
              @response = Struct::TmrkEcloudPublicIpList.new([])
            end

            def start_element(name, attributes)
              @value = nil
              case name
              when 'PublicIPAddress'
                @ip_address = Struct::TmrkEcloudPublicIp.new("application/vnd.tmrk.ecloud.publicIp+xml")
              end
            end

            def end_element(name)
              case name
              when 'Href'
                @ip_address[name.downcase] = URI.parse(@value)
              when 'Name'
                @ip_address[name.downcase] = @value
              when 'Id'
                @ip_address[name.downcase] = @value.to_i
              when 'PublicIPAddress'
                @response.links << @ip_address
              end
            end

          end
        end
      end
    end
  end
end

