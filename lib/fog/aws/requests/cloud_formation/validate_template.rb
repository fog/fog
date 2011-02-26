module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/get_template'

        # Describe stacks
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'TemplateBody'<~String> - template structure
        #   * 'TemplateURL'<~String> - template url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Description'<~String> - description found within the template
        #     * 'Parameters'<~String> - list of template parameter structures
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_ValidateTemplate.html
        #
        def validate_template(options = {})
          request({
            'Action'    => 'GetTemplate',
            :parser     => Fog::Parsers::AWS::CloudFormation::GetTemplate.new
          }.merge!(options))
        end

      end
    end
  end
end
