module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Ecloud

          class GetPublicIp < Fog::Parsers::Vcloud::Base

            def reset
              @response = Struct::TmrkEcloudPublicIp.new("application/vnd.tmrk.ecloud.publicIp+xml")
            end

            def end_element(name)
              case name
              when 'Href'
                @response[name.downcase] = URI.parse(@value)
              when 'Name'
                @response[name.downcase] = @value
              when 'Id'
                @response['id'] = @value.to_i
              end
            end

          end
        end
      end
    end
  end
end

