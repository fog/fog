module Fog
  module Parsers
    module AWS
      module AutoScaling

        class DescribeScalingProcessTypes < Fog::Parsers::Base

          def reset
            reset_process_type
            @results = { 'Processes' => [] }
            @response = { 'DescribeScalingProcessTypesResult' => {}, 'ResponseMetadata' => {} }
          end

          def reset_process_type
            @process_type = {}
          end

          def end_element(name)
            case name
            when 'member'
              @results['Processes'] << @process_type
              reset_process_type

            when 'ProcessName'
              @process_type[name] = value

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'DescribeScalingProcessTypesResponse'
              @response['DescribeScalingProcessTypesResult'] = @results
            end
          end

        end
      end
    end
  end
end
