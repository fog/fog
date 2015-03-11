require 'fog/core/model'

module Fog
  module Openstack
    class Planning
      class Plan < Fog::Model

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
      end
    end
  end
end
