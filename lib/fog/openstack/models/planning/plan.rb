require 'fog/core/model'

module Fog
  module Openstack
    class Planning
      class Plan < Fog::Model

        MASTER_TEMPLATE_NAME = 'plan.yaml'
        ENVIRONMENT_NAME = 'environment.yaml'

        identity :uuid

        attribute :description
        attribute :name
        attribute :uuid
        attribute :created_at
        attribute :updated_at
        attribute :parameters

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def templates
          service.get_plan_templates(uuid).body
        end

        def master_template
          templates[MASTER_TEMPLATE_NAME]
        end

        def environment
          templates[ENVIRONMENT_NAME]
        end

        def provider_resource_templates
          templates.select do |key, template|
            ![MASTER_TEMPLATE_NAME, ENVIRONMENT_NAME].include?(key)
          end
        end

        def add_role(role_uuid)
          service.add_role_to_plan(uuid, role_uuid)
        end

        def remove_role(role_uuid)
          service.remove_role_from_plan(uuid, role_uuid)
        end
      end
    end
  end
end
