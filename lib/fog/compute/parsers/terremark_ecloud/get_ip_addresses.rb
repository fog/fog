module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetIpAddresses < Fog::Parsers::Base

          def reset
            @response = { 'IpAddresses' => [] }
            @ip_address = {}
          end

          def end_element(name)
            case name
            when 'Id', 'Href', 'Name', 'RnatAddress', 'Server', 'Status'
              @ip_address[name] = @value
            when 'IpAddress'
              @response['IpAddresses'] << @ip_address
              @ip_address = {}
            end
          end

        end
      end
    end
  end
end
