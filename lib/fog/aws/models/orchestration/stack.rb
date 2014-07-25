require 'fog/orchestration/models/stack'
require 'fog/aws/models/orchestration/events'
require 'fog/aws/models/orchestration/resources'
require 'fog/aws/models/orchestration/outputs'

module Fog
  module Orchestration
    class AWS
      # Stack instance
      class Stack < Fog::Orchestration::Stack

        # Register stack resources class
        resources Fog::Orchestration::AWS::Resources
        # Register stack events class
        events Fog::Orchestration::AWS::Events
        # Register stack outputs class
        outputs Fog::Orchestration::AWS::Outputs

        attribute :stack_name, :aliases => ['StackName']
        attribute :id, :aliases => ['StackId']
        attribute :template_description, :aliases => ['TemplateDescription']
        attribute :creation_time, :aliases => ['CreationTime']
        attribute :stack_status, :aliases => ['StackStatus']
        attribute :deletion_time, :aliases => ['DeletionTime']
        attribute :disable_rollback, :aliases => ['DisableRollback']
        attribute :parameters, :aliases => ['Parameters']
        attribute :capabilities, :aliases => ['Capabilities']

        # valid options for stack create and update actions
        ALLOWED_OPTIONS = {
          :create => [
            :template, :template_url, :disable_rollback, :parameters, :timeout_in_minutes, :capabilities
          ],
          :update => [
            :template, :template_url, :parameters
          ]
        }

        # option name remapping for API request
        OPTIONS_MAPPING = {
          :template => 'TemplateBody',
          :parameters => 'Parameters',
          :capabilities => 'Capabilities',
          :disable_rollback => 'DisableRollback',
          :timeout_in_minutes => 'TimeoutInMinutes',
          :notification_arns => 'NotificationARNs'
        }

        # Generate API options hash for action
        #
        # @param action [String, Symbol] :create or :update
        # @return [Hash]
        def api_arguments_for(action)
          args = Hash[
            self.attributes.find_all do |key, value|
              ALLOWED_OPTIONS[action.to_sym].include?(key)
            end
          ]
          OPTIONS_MAPPING.each do |original, mapped|
            val = args.delete(original)
            if(val)
              args[mapped] = val
            end
          end
          args
        end

        # Create the stack
        #
        # @return [self]
        def create
          requires :stack_name
          args = api_arguments_for(:create)
          service.create_stack(stack_name, args)
          self
        end

        # Update the stack
        #
        # @return [self]
        def update
          requires :stack_name, :id
          args = api_arguments_for(:update)
          service.update_stack(stack_name, args)
          self
        end

        # Destroy the stack
        #
        # @return [self]
        def destroy
          requires :stack_name, :id
          service.delete_stack(self.stack_name)
          self
        end

        # @return [String] template JSON
        def template
          if(persisted? && !attributes[:template])
            attributes[:template] = service.get_template(stack_name).
              body['TemplateBody']
          end
          attributes[:template]
        end

        # Validate the template of the stack
        #
        # @return [TrueClass]
        # @raises [Fog::Errors::OrchestrationError::InvalidTemplate]
        def validate
          unless(self.template || self.template_url)
            raise ArgumentError.new('Stack must defined `template` or `template_url`')
          end
          begin
            if(template)
              validate_args = {'TemplateBody' => self.template}
            else
              validate_args = {'TemplateURL' => self.template_url}
            end
            service.validate_template(validate_args)
            true
          rescue Fog::AWS::CloudFormation::NotFound => e
            raise Fog::Errors::OrchestrationError::InvalidTemplate.new e.message
          end
        end

        # @return [TrueClass, FalseClass]
        def exists?
          persisted? &&
            self.stack_status != 'DELETE_COMPLETE'
        end

        # @return [Hash] stack parameters
        def parameters
          Hash[
            attributes.fetch(:parameters, []).map do |param_hash|
              [param_hash['ParameterKey'], param_hash['ParameterValue']]
            end
          ]
        end

        # Customized reload to affect only this instance
        #
        # @return [self]
        def reload
          requires :identity
          describe = service.describe_stacks('StackName' => stack_name).body['Stacks'].first
          merge_attributes(self.class.new(describe).attributes)
          attributes.delete('Events')
          attributes.delete('Resources')
          self
        end

      end
    end
  end
end
