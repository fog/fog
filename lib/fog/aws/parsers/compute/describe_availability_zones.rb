module Fog
  module Parsers
    module AWS
      module Compute

        class DescribeAvailabilityZones < Fog::Parsers::Base

          def reset
            @availability_zone = {}
            @response = { 'availabilityZoneInfo' => [] }
          end

          def end_element(name)
            case name
            when 'item'
              @response['availabilityZoneInfo'] << @availability_zone
              @availability_zone = {}
            when 'regionName', 'zoneName', 'zoneState'
              @availability_zone[name] = @value
            when 'requestId'
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end
