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

        attr_accessor :data

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

        # Attributes requiring expansion
        # Allows for lazy loading details
        %w(capabilities outputs parameters).each do |m_name|
          define_method "#{m_name}_wrapper" do
            expand! unless data
            send("#{m_name}_unwrapped")
          end
          alias_method "#{m_name}_unwrapped", m_name
          alias_method m_name, "#{m_name}_wrapper"
        end

        def expand!
          requires :stack_name, :id
          if(data.nil? && exists?)
            @data = service.describe_stacks('StackName' => self.stack_name).body['Stacks'].first
            merge_attributes(data)
          end
          data
        end

        def exists?
          self.stack_status != 'DELETE_COMPLETE'
        end

      end
    end
  end
end
