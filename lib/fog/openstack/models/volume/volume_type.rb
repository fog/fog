require 'fog/core/model'

module Fog
  module Volume
    class OpenStack
      class VolumeType < Fog::Model
        identity :id

        attribute :name
        attribute :volume_backend_name

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end
      end
    end
  end
end
