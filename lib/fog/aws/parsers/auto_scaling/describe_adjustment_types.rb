module Fog
  module Parsers
    module AWS
      module AutoScaling

        class DescribeAdjustmentTypes < Fog::Parsers::Base

          def reset
            reset_adjustment_type
            @results = { 'AdjustmentTypes' => [] }
            @response = { 'DescribeAdjustmentTypesResult' => {}, 'ResponseMetadata' => {} }
          end

          def reset_adjustment_type
            @adjustment_type = {}
          end

          def end_element(name)
            case name
            when 'member'
              @results['AdjustmentTypes'] << @adjustment_type
              reset_adjustment_type

            when 'AdjustmentType'
              @adjustment_type[name] = value

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'DescribeAdjustmentTypesResponse'
              @response['DescribeAdjustmentTypesResult'] = @results
            end
          end

        end
      end
    end
  end
end
