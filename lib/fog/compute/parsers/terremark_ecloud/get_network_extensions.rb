module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetNetworkExtensions < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'Name'
              @response['name'] = @value
            when 'Href'
              @response['uri'] = @value
            when 'RnatAddress'
              @response['rnatAddress'] = @value
            when 'Address'
              @response['address'] = @value
            when 'BroadcastAddress'
              @response['broadcastAddress'] = @value
            when 'GatewayAddress'
              @response['gatewayAddress'] = @value
            when 'NetworkType'
              @response['type'] = @value
            when 'FriendlyName'
              @response['friendlyName'] = @value
            end
          end

        end
      end
    end
  end
end
