require 'fog/core/model'

module Fog
  module Metering
    class OpenStack
      class Resource < Fog::Model
        identity :resource_id

        attribute :project_id
        attribute :user_id
        attribute :metadata

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end
      end
    end
  end
end
