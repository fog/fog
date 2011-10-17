module Fog
  module AWS
    class CloudFormation
      class Real

        require 'fog/aws/parsers/cloud_formation/create_stack'

        # Create a stack
        #
        # ==== Parameters
        # * stack_name<~String>: name of the stack to create
        # * options<~Hash>:
        #   * TemplateBody<~String>: structure containing the template body
        #   or (one of the two Template parameters is required)
        #   * TemplateURL<~String>: URL of file containing the template body
        #   * DisableRollback<~Boolean>: Controls rollback on stack creation failure, defaults to false
        #   * NotificationARNs<~Array>: List of SNS topics to publish events to
        #   * Parameters<~Hash>: Hash of providers to supply to template
        #   * TimeoutInMinutes<~Integer>: Minutes to wait before status is set to CREATE_FAILED
        #   * Capabilities<~Array>: List of capabilties the stack is granted. Currently CAPABILITY_IAM
        #     for allowing the creation of IAM resources
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
          params = {
            'StackName' => stack_name,
          }

          if options['DisableRollback']
            params['DisableRollback'] = options['DisableRollback']
          end

          if options['NotificationARNs']
            params.merge!(Fog::AWS.indexed_param("NotificationARNs.member", [*options['NotificationARNs']]))
          end

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

          if options['TimeoutInMinutes']
            params['TimeoutInMinutes'] = options['TimeoutInMinutes']
          end
          
          if options['Capabilities']
            params.merge!(Fog::AWS.indexed_param("Capabilities.member", [*options['Capabilities']]))
          end

          request({
            'Action'    => 'CreateStack',
            :parser     => Fog::Parsers::AWS::CloudFormation::CreateStack.new
          }.merge!(params))
        end

      end
    end
  end
end
