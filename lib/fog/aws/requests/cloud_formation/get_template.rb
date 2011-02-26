module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/get_template'

        # Describe stacks
        #
        # ==== Parameters
        # * stack_name<~String> - stack name to get template from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'TemplateBody'<~String> - structure containing the template body (json)
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_GetTemplate.html
        #
        def get_template(stack_name)
          request(
            'Action'    => 'GetTemplate',
            'StackName' => stack_name,
            :parser     => Fog::Parsers::AWS::CloudFormation::GetTemplate.new
          )
        end

      end
    end
  end
end
