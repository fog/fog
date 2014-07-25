require 'fog/orchestration/models/stack'
require 'fog/rackspace/models/orchestration/events'
require 'fog/rackspace/models/orchestration/resources'
require 'fog/rackspace/models/orchestration/outputs'

module Fog
  module Orchestration
    class Rackspace
      class Stack < Fog::Orchestration::Stack

        # Register stack resources class
        resources Fog::Orchestration::Rackspace::Resources
        # Register stack events class
        events Fog::Orchestration::Rackspace::Events
        # Register stack outputs class
        outputs Fog::Orchestration::Rackspace::Outputs

        attribute :links

        # valid options for stack create and update actions
        ALLOWED_OPTIONS = {
          :create => [
            :template, :template_url, :disable_rollback, :parameters, :timeout_in_minutes
          ],
          :update => [
            :template, :template_url, :parameters
          ]
        }

        # option name remapping for API request
        OPTIONS_MAPPING = {
          :timeout_in_minutes => :timeout_mins
        }

        # lazy loaded attributes requiring data expansion
        EXPAND_FOR_ATTRIBUTES = [
          :disable_rollback,
          :capabilities,
          :timeout_in_minutes
        ]

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
          requires :stack_name
          args = api_arguments_for(:update)
          service.update_stack(stack_name, args)
          self
        end

        # Destroy the stack
        #
        # @return [self]
        def destroy
          requires :stack_name, :id
          service.delete_stack(self.stack_name, self.id)
          self
        end

        # @return [String] template JSON
        def template
          if(persisted? && !attributes[:template])
            stack_template = service.template_stack(self.stack_name, self.id).body
            # Force string if body was auto converted
            unless(stack_template.is_a?(String))
              stack_template = Fog::JSON.encode(stack_template)
            end
            attributes[:template] = stack_template
          end
          attributes[:template]
        end

        # Validate the template of the stack
        #
        # @return [TrueClass]
        # @raises [Fog::Errors::OrchestrationError::InvalidTemplate]
        def validate
          unless(self.template || self.template_url)
            raise ArgumentError.new('Stack must define `template` or `template_url`')
          end
          begin
            if(template)
              validate_args = {'template' => self.template}
            else
              validate_args = {'template_url' => self.template_url}
            end
            service.template_validate(validate_args)
            true
          rescue Fog::Orchestration::Rackspace::BadRequest => e
            raise Fog::Errors::OrchestrationError::InvalidTemplate.new(
              e.response_data['explanation']
            )
          end
        end

        # @return [TrueClass, FalseClass]
        def exists?
          persisted? &&
            self.stack_status != 'DELETE_COMPLETE'
        end

        # Force data expansion for lazy loaded attributes
        EXPAND_FOR_ATTRIBUTES.each do |attribute_name|
          define_method(attribute_name) do
            expand!
            super
          end
        end

        # Load full stack data into attributes
        #
        # @return [Hash] raw data hash
        def expand!
          unless(@expanded)
            data = service.data_stack(self.stack_name, self.id).body['stack']
            merge_attributes(data)
          end
          data
        end

      end
    end
  end
end
