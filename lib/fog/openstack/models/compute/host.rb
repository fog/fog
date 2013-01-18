require 'fog/compute/models/server'
require 'fog/openstack/models/compute/metadata'

module Fog
  module Compute
    class OpenStack

      class Host < Fog::Model

        attribute :host_name
        attribute :service
        attribute :details

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def details
          service.get_host_details(self.host_name).body['host']
        end

      end

    end
  end

end
