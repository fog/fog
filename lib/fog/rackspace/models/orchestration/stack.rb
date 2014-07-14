require 'fog/orchestration/models/stack'
require 'fog/rackspace/models/orchestration/events'
require 'fog/rackspace/models/orchestration/resources'
require 'fog/rackspace/models/orchestration/outputs'

module Fog
  module Orchestration
    class Rackspace
      class Stack < Fog::Orchestration::Stack

        resources Fog::Orchestration::Rackspace::Resources
        events Fog::Orchestration::Rackspace::Events
        outputs Fog::Orchestration::Rackspace::Outputs

        attribute :links

        attr_accessor :data

        ALLOWED_OPTIONS = {
          :create => [
            :template, :template_url, :disable_rollback, :parameters, :timeout_in_minutes
          ],
          :update => [
            :template, :template_url, :parameters
          ]
        }

        def create
          requires :stack_name
          args = self.attributes.find_all do |key, value|
            ALLOWED_OPTIONS[:create].include?(key)
          end
          service.create_stack(stack_name, Hash[args])
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
          requires :stack_name, :id
          if(!attributes[:template])
            stack_template = service.template_stack(self.stack_name, self.id).body
            attributes[:template] = stack_template.is_a?(String) ? stack_template : Fog::JSON.encode(stack_template)
          end
          attributes[:template]
        end

        # Attributes requiring expansion
        # Allows for lazy loading details
        %w(resources events outputs template_description timeout_in_minutes).each do |m_name|
          define_method m_name do
            expand! unless data
            super()
          end
        end

        def expand!
          unless(data)
            @data = service.data_stack(self.stack_name, self.id).body['stack']
            data.each_pair do |key, value|
              if(self.class.attributes.map(&:to_s).include?(key) && self.respond_to?("#{key}="))
                self.send("#{key}=", value)
              end
            end
            self.timeout_in_minutes = data['timeout_mins']
            self.template_description = data['description']
          end
          data
        end

      end
    end
  end
end
