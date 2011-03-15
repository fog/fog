module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/describe_stack_events'

        # Describe stack events
        #
        # ==== Parameters
        # * stack_name<~String>: stack name to return events for
        # * options<~Hash>:
        #   * NextToken<~String>: identifies the start of the next list of events, if there is one
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'StackEvents'<~Array> - Matching resources
        #       * event<~Hash>:
        #         * 'EventId'<~String> -
        #         * 'StackId'<~String> -
        #         * 'StackName'<~String> -
        #         * 'LogicalResourceId'<~String> -
        #         * 'PhysicalResourceId'<~String> -
        #         * 'ResourceType'<~String> -
        #         * 'Timestamp'<~Time> -
        #         * 'ResourceStatus'<~String> -
        #         * 'ResourceStatusReason'<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_DescribeStackEvents.html
        #
        def describe_stack_events(stack_name, options = {})
          request({
            'Action'    => 'DescribeStackEvents',
            'StackName' => stack_name,
            :parser     => Fog::Parsers::AWS::CloudFormation::DescribeStackEvents.new
          }.merge!(options))
        end

      end
    end
  end
end
