require 'fog/core/model'

module Fog
  module Orchestration
    class OpenStack
      class Stack < Fog::Model
        identity :id

        attribute :stack_name
        attribute :stack_status
        attribute :stack_status_reason
        attribute :creation_time
        attribute :updated_time
        attribute :id

        attribute :template_url
        attribute :template
        attribute :parameters
        attribute :timeout_in_minutes

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          requires :stack_name
          identity ? update : create
        end

        def create
          requires :stack_name
          service.create_stack(stack_name, self.attributes)
          self
        end

        def update
          requires :stack_name
          service.update_stack(stack_name, self.attributes)
          self
        end

        def destroy
          requires :id
          service.delete_stack(self.stack_name, self.id)
          true
        end
      end
    end
  end
end
