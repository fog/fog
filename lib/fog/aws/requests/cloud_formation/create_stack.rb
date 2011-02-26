module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/create_stack'

        # Create a stack
        # 
        # ==== Parameters
        # * stack_name<~String>: name of the stack to create
        # * options<~Hash>
        #   * TemplateBody<~String>: structure containing the template body
        #   or
        #   * TemplateURL<~String>: URL of file containing the template body
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'StackId'<~String> - Id of the new stack
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html
        #
        def create_stack(stack_name, options = {})
          request({
            'Action'    => 'CreateStack',
            'StackName' => stack_name,
            :parser     => Fog::Parsers::AWS::CloudFormation::CreateStack.new
          }.merge!(options))
        end

      end
    end
  end
end
