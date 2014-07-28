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
          :capabilities,
          :disable_rollback,
          :parameters,
          :timeout_in_minutes
        ]

        # Generate API options hash for action
        #
        # @param action [String, Symbol] :create or :update
        # @return [Hash]
        def api_arguments_for(action)
          args = Hash[
            ALLOWED_OPTIONS[action.to_sym].map do |key|
              val = self.send(key)
              if(val)
                [key, val]
              end
            end.compact
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
          filter_parameters_for_update!(args.fetch(:parameters, {}))
          service.update_stack(id, stack_name, args)
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

        # Set stack template
        #
        # @param template_body [String, Hash] stack template
        # @return [String]
        # @note if data structure provided, it will be dumped to JSON
        #   content and stored
        def template=(template_body)
          unless(template_body.is_a?(String))
            template_body = Fog::JSON.encode(template_body)
          end
          attributes[:template] = template_body
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
          define_method("expander_#{attribute_name}") do
            expand!
            send("unexpander_#{attribute_name}")
          end
          alias_method "unexpander_#{attribute_name}".to_sym, attribute_name.to_sym
          alias_method attribute_name.to_sym, "expander_#{attribute_name}".to_sym
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

        # Remove parameters not defined within template
        #
        # @param params [Hash] new stack parameters
        # @return [Hash] filtered parameters
        def filter_parameters_for_update!(params)
          template_struct = Fog::JSON.decode(template)
          valid = template_struct.fetch('Parameters',
            template_struct.fetch('parameters', {})
          )
          params.keys.each do |key|
            params.delete(key) unless valid.include?(key)
          end
          params
        end

      end
    end
  end
end
