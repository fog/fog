module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/describe_stacks'

        # Describe stacks
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'StackName'<~String>: name of the stack to describe
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Stacks'<~Array> - Matching stacks
        #       * stack<~Hash>:
        #         * 'StackName'<~String> -
        #         * 'StackId'<~String> -
        #         * 'CreationTime'<~String> -
        #         * 'StackStatus'<~String> -
        #         * 'DisableRollback'<~String> -
        #         * 'Outputs'<~Array> -
        #           * output<~Hash>:
        #             * 'OutputKey'<~String> -
        #             * 'OutputValue'<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_DescribeStacks.html
        #
        def describe_stacks(options = {})
          request({
            'Action'    => 'DescribeStacks',
            :parser     => Fog::Parsers::AWS::CloudFormation::DescribeStacks.new
          }.merge!(options))
        end

      end
    end
  end
end
