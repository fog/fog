module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Ecloud

          class GetInternetServices < Fog::Parsers::Vcloud::Base

            def reset
              @response = Struct::TmrkEcloudList.new([])
              @in = nil
              @public_ip = nil
            end

            def start_element(name, attributes)
              @value = nil
              case name
              when 'InternetService'
                @in = :service
                @service = Struct::TmrkEcloudInternetService.new("application/vnd.tmrk.ecloud.internetService+xml")
              when 'PublicIpAddress'
                @in = :public_ip
                @public_ip = Struct::TmrkEcloudPublicIp.new("application/vnd.tmrk.ecloud.publicIp+xml")
              end
            end

            def end_element(name)
              target = case @in
              when :service
                @service
              when :public_ip
                @public_ip
              end

              case name
              when 'Href'
                target[name.downcase] = URI.parse(@value)
              when 'Name', 'Protocol', 'Description', 'SendString', 'HttpHeader'
                #The gsub takes the CamelCase names and turns them into camel_case
                target[Fog::Parsers::Vcloud.de_camel(name)] = @value
              when 'Id', 'Port', 'Timeout'
                target[name.downcase] = @value.to_i
              when 'Enabled'
                @service[name.downcase] = ( @value == "true" ? true : false )
              when 'InternetService'
                @response.links << @service
                @in = nil
              when 'PublicIpAddress'
                @service.public_ip = @public_ip
                @in = :service
              end
            end

          end
        end
      end
    end
  end
end
