module Fog
  module Parsers
    module AWS
      module AutoScaling

        class DescribePolicies < Fog::Parsers::Base

          def reset
            reset_scaling_policy
            reset_alarm
            @results = { 'ScalingPolicies' => [] }
            @response = { 'DescribePoliciesResult' => {}, 'ResponseMetadata' => {} }
          end

          def reset_scaling_policy
            @scaling_policy = { 'Alarms' => [] }
          end

          def reset_alarm
            @alarm = {}
          end

          def end_element(name)
            case name
            when 'member'
              @scaling_policy['Alarms'] << @alarm
              reset_alarm

            when 'AlarmARN', 'AlarmName'
              @alarm[name] = value

            when 'AdjustmentType', 'AutoScalingGroupName', 'PolicyARN', 'PolicyName'
              @scaling_policy[name] = value
            when 'Cooldown', 'ScalingAdjustment'
              @results[name] = value.to_i

            when 'NextToken'
              @results[name] = value

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'DescribePoliciesResponse'
              @response['DescribePoliciesResult'] = @results
            end
          end

        end
      end
    end
  end
end
