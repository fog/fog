require 'fog/aws/models/auto_scaling/group'

module Fog
  module AWS
    class AutoScaling
      class Groups < Fog::Collection

        model Fog::AWS::AutoScaling::Group

        # Creates a new auto scaling group.
        def initialize(attributes={})
          super
        end

        def all
          data = []
          next_token = nil
          loop do
            result = connection.describe_auto_scaling_groups('NextToken' => next_token).body['DescribeAutoScalingGroupsResult']
            data += result['AutoScalingGroups']
            next_token = result['NextToken']
            break if next_token.nil?
          end
          load(data)
        end

        def get(identity)
          data = connection.describe_auto_scaling_groups('AutoScalingGroupNames' => identity).body['DescribeAutoScalingGroupsResult']['AutoScalingGroups'].first
          new(data) unless data.nil?
        end

      end
    end
  end
end
