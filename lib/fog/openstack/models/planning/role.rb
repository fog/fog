require 'fog/core/model'

module Fog
  module Openstack
    class Planning
      class Role < Fog::Model
        identity :uuid

        attribute :description
        attribute :name
        attribute :uuid

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def add_to_plan(plan_uuid)
          service.add_role_to_plan(plan_uuid, uuid)
        end

        def remove_from_plan(plan_uuid)
          service.remove_role_from_plan(plan_uuid, uuid)
        end
      end
    end
  end
end
