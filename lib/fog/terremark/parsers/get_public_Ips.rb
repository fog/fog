module Fog
  module Parsers
    module Terremark

      class GetPublicIps< Fog::Parsers::Base

        def reset
          @ip_address = {}
          @response = { 'PublicIpAddresses' => [] }
        end

        def end_element(name)
          case name
          when 'Href', 'Name'
            @ip_address[name] = @value
          when 'Id'
            @ip_address[name] = @value.to_i
          when 'PublicIPAddress'
            @response['PublicIpAddresses'] << @ip_address
            @ip_address = {}
          end
        end

      end

    end
  end
end
