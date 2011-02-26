module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/describe_stack_events'

        # Describe stack events
        # 
        # ==== Parameters
        # * options<~Hash>:
        #   * StackName<~String>: only return events related to this stack name
        #   * NextToken<~String>: identifies the start of the next list of events, if there is one
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Events'<~Array> - Matching resources
        #       * event<~Hash>:
        #         * 'EventId'<~String> -
        #         * 'StackId'<~String> -
        #         * 'StackName'<~String> -
        #         * 'LogicalResourceId'<~String> -
        #         * 'PhysicalResourceId'<~String> -
        #         * 'ResourceType'<~String> -
        #         * 'Timestamp'<~String> -
        #         * 'ResourceStatus'<~String> -
        #         * 'ResourceStatusReason'<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_DescribeStackEvents.html
        #
        def describe_stack_events(options = {})
          request({
            'Action'    => 'DescribeStackEvents',
            :parser     => Fog::Parsers::AWS::CloudFormation::DescribeStackEvents.new
          }.merge!(options))
        end

      end
    end
  end
end
