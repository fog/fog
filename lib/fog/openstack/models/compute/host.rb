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
          @connection = attributes[:connection]
          super
        end

        def details
          connection.get_host_details(self.host_name).body['host']
        end

      end

    end
  end

end
