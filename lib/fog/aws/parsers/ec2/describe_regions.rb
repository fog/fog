module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeRegions < Fog::Parsers::Base

          def reset
            @region = {}
            @response = { :region_info => [] }
          end

          def end_element(name)
            case name
            when 'item'
              @response[:region_info] << @region
              @region = {}
            when 'regionEndpoint'
              @region[:region_endpoint] = @value
            when 'regionName'
              @region[:region_name] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

      end
    end
  end
end