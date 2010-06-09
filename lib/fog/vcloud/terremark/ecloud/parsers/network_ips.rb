module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Ecloud

          class NetworkIps< Fog::Parsers::Vcloud::Base

            def reset
              @response = Struct::TmrkEcloudNetworkIps.new([])
              @ip_address = Struct::TmrkEcloudNetworkIp.new
            end

            def end_element(name)
              case name
              when 'Name', 'Status', 'Server'
                @ip_address[name.downcase] = @value
              when 'IpAddress'
                @response.addresses << @ip_address
                @ip_address = Struct::TmrkEcloudNetworkIp.new
              end
            end

          end
        end
      end
    end
  end
end


