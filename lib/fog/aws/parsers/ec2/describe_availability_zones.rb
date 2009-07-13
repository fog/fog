module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeAvailabilityZones < Fog::Parsers::Base

          def reset
            @zone = {}
            @response = { :availability_zone_info => [] }
          end

          def end_element(name)
            case name
            when 'item'
              @response[:availability_zone_info] << @zone
              @zone = {}
            when 'regionName'
              @zone[:region_name] = @value
            when 'requestId'
              @response[:request_id] = @value
            when 'zoneName'
              @zone[:zone_name] = @value
            when 'zoneState'
              @zone[:zone_state] = @value
            end
          end

        end

      end
    end
  end
end