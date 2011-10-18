require 'fog/aws/models/auto_scaling/activity'

module Fog
  module AWS
    class AutoScaling
      class Activities < Fog::Collection

        model Fog::AWS::AutoScaling::Activity

        def all
          data = []
          next_token = nil
          loop do
            result = connection.describe_scaling_activities('NextToken' => next_token).body['DescribeScalingActivitiesResult']
            data += result['Activities']
            next_token = result['NextToken']
            break if next_token.nil?
          end
          load(data)
        end

        def get(identity)
          data = connection.describe_scaling_activities('ActivityId' => identity).body['DescribeScalingActivitiesResult']['Activities'].first
          new(data) unless data.nil?
        end

      end
    end
  end
end
