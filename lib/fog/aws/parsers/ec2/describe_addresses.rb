module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeAddresses < Fog::Parsers::Base

          def reset
            @address = {}
            @response = { :address_set => [] }
          end

          def end_element(name)
            case name
            when 'instanceId'
              @address[:instance_id] = @value
            when 'item'
              @response[:address_set] << @address
              @address = []
            when 'publicIp'
              @address[:public_ip] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

      end
    end
  end
end
