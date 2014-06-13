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

        def template_wrapper
          if(persisted? && exists? && !template_unwrapped)
            self.template = Fog::JSON.decode(service.get_template(stack_name).body['TemplateBody'])
          end
          template_unwrapped
        end
        alias_method :template_unwrapped, :template
        alias_method :template, :template_wrapper

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

        alias_method :direct_resources, :resources

        def resources
          if(attributes[:stack_resources].nil?)
            attributes[:stack_resources] = direct_resources
          elsif(attributes[:stack_resources].first.is_a?(Hash))
            attributes[:stack_resources] = Resources.new(
              :service => service,
              :stack_name => stack_name
            ).load(attributes[:stack_resources])
          end
          attributes[:stack_resources]
        end

      end
    end
  end
end
