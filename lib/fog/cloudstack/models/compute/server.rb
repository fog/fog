require 'fog/compute/models/server'

module Fog
  module Compute
    class Cloudstack

      class Server < Fog::Compute::Server
        extend Fog::Deprecation

        identity :id, :aliases => 'instanceId'

        attribute :name, :aliases => 'name'
        attribute :display_name, :aliases => 'displayName'
        attribute :flavor_id, :aliases => 'instanceType'
        attribute :image_id, :aliases => 'imageId'
        attribute :public_ip_address, :aliases => 'ipAddress'
        attribute :state, :aliases => 'instanceState'

        def initialize(attributes={})
          super
        end

      end
    end
  end
end
