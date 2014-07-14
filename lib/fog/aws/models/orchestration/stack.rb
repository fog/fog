require 'fog/orchestration/models/stack'
require 'fog/aws/models/orchestration/events'
require 'fog/aws/models/orchestration/resources'
require 'fog/aws/models/orchestration/outputs'

module Fog
  module Orchestration
    class AWS
      class Stack < Fog::Orchestration::Stack

        resources Fog::Orchestration::AWS::Resources
        events Fog::Orchestration::AWS::Events
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

        ALLOWED_OPTIONS = {
          :create => [
            :template, :template_url, :disable_rollback, :parameters, :timeout_in_minutes, :capabilities
          ],
          :update => [
            :template, :template_url, :parameters
          ]
        }

        CREATE_MAP = {
          :template => 'TemplateBody',
          :parameters => 'Parameters',
          :capabilities => 'Capabilities',
          :disable_rollback => 'DisableRollback',
          :timeout_in_minutes => 'TimeoutInMinutes',
          :notification_arns => 'NotificationARNs'
        }
        def create
          requires :stack_name, :template
          args = self.attributes.find_all do |key, value|
            ALLOWED_OPTIONS[:create].include?(key)
          end

          args = Hash[args]

          create_args = {}.tap do |c_args|
            CREATE_MAP.each do |orig, convrt|
              c_args[convrt] = args[orig] if args[orig]
            end
          end

          service.create_stack(stack_name, create_args)
          self
        end

        def update
          requires :stack_name
          args = self.attributes.find_all do |key, value|
            ALLOWED_OPTIONS[:update].include?(key)
          end
          service.update_stack(stack_name, Hash[args])
          self
        end

        def destroy
          requires :id
          service.delete_stack(self.stack_name, self.id)
          true
        end

        def template
          if(persisted? && !attributes[:template])
            attributes[:template] = service.get_template(stack_name).
              body['TemplateBody']
          end
          attributes[:template]
        end

        def validate
          if(template)
            service.validate_template('TemplateBody' => template)
          elsif(template_url)
            service.validate_template('TemplateURL' => template_url)
          else
            raise 'No template provided to validate'
          end
        end

        def exists?
          self.stack_status != 'DELETE_COMPLETE'
        end

        def parameters
          Hash[
            attributes.fetch(:parameters, []).map do |param_hash|
              [param_hash['ParameterKey'], param_hash['ParameterValue']]
            end
          ]
        end

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
