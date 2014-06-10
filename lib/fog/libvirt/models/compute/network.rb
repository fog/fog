require 'fog/core/model'
require 'fog/libvirt/models/compute/util/util'

module Fog
  module Compute
    class Libvirt
      class Network < Fog::Model
        include Fog::Compute::LibvirtUtil

        identity :uuid
        attribute :name
        attribute :bridge_name
        attribute :xml

        def initialize(attributes = {})
          super
        end

        def save
          raise Fog::Errors::Error.new('Creating a new network is not yet implemented. Contributions welcome!')
        end

        def shutdown
          service.destroy_network(uuid)
        end
      end
    end
  end
end
