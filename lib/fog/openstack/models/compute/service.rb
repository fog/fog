require 'fog/core/model'

module Fog
  module Compute
    class OpenStack
      class Service < Fog::Model
        identity :id

        attribute :binary
        attribute :host
        attribute :state
        attribute :status
        attribute :updated_at
        attribute :zone

        #detailed
        attribute :disabled_reason

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def enable
          requires :binary, :host
          service.enable_service(self.host, self.binary)
        end

        def disable
          requires :binary, :host
          service.disable_service(self.host, self.binary)
        end

        def disable_and_log_reason
          requires :binary, :host, :disabled_reason
          service.disable_service_log_reason(self.host, self.binary, self.disabled_reason)
        end

        def destroy
          requires :id
          service.delete_service(self.id)
          true
        end
      end
    end
  end
end
