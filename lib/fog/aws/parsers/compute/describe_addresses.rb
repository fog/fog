module Fog
  module Parsers
    module Compute
      module AWS

        class DescribeAddresses < Fog::Parsers::Base

          def reset
            @address = {}
            @response = { 'addressesSet' => [] }
          end

          def end_element(name)
            case name
            when 'instanceId', 'publicIp', 'domain', 'allocationId'
              @address[name] = value
            when 'item'
              @response['addressesSet'] << @address
              @address = {}
            when 'requestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
