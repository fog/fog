module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/basic'

        # Delete a stack
        #
        # ==== Parameters
        # * stack_name<~String>: name of the stack to create
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_DeleteStack.html
        #
        def delete_stack(stack_name)
          request(
            'Action'    => 'DeleteStack',
            'StackName' => stack_name,
            :parser     => Fog::Parsers::AWS::CloudFormation::Basic.new
          )
        end

      end
    end
  end
end
