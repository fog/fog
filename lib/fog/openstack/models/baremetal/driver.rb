require 'fog/core/model'

module Fog
  module Baremetal
    class OpenStack
      class Driver < Fog::Model
        identity :name

        attribute :name
        attribute :hosts

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def properties
          requires :name
          service.get_driver_properties(self.name).body
        end

        def metadata
          requires :name
          service.get_driver(self.name).headers
        end
      end
    end
  end
end
