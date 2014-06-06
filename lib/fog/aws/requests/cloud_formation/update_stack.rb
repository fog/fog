module Fog
  module AWS
    class CloudFormation
      class Real
        require 'fog/aws/parsers/cloud_formation/update_stack'

        # Update a stack.
        #
        # @param [String] stack_name Name of the stack to update.
        # @param [Hash] options
        #   * TemplateBody [String] Structure containing the template body.
        #   or (one of the two Template parameters is required)
        #   * TemplateURL [String] URL of file containing the template body.
        #   * Parameters [Hash] Hash of providers to supply to template.
        #   * Capabilities [Array] List of capabilties the stack is granted. Currently CAPABILITY_IAM for allowing the creation of IAM resources.
        #
        # @return [Excon::Response]
        #   * body [Hash]:
        #     * StackId [String] - Id of the stack being updated
        #
        # @see http://docs.amazonwebservices.com/AWSCloudFormation/latest/APIReference/API_UpdateStack.html
        #
        def update_stack(stack_name, options = {})
          params = {
            'StackName' => stack_name,
          }

          if options['Parameters']
            options['Parameters'].keys.each_with_index do |key, index|
              index += 1 # params are 1-indexed
              params.merge!({
                "Parameters.member.#{index}.ParameterKey"   => key,
                "Parameters.member.#{index}.ParameterValue" => options['Parameters'][key]
              })
            end
          end

          if options['TemplateBody']
            params['TemplateBody'] = options['TemplateBody']
          elsif options['TemplateURL']
            params['TemplateURL'] = options['TemplateURL']
          end

          if options['Capabilities']
            params.merge!(Fog::AWS.indexed_param("Capabilities.member", [*options['Capabilities']]))
          end

          request({
            'Action'    => 'UpdateStack',
            :parser     => Fog::Parsers::AWS::CloudFormation::UpdateStack.new
          }.merge!(params))
        end
      end
    end
  end
end
