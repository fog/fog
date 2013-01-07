require 'fog/core/collection'
require 'fog/libvirt/models/compute/node'

module Fog
  module Compute
    class Libvirt

      class Nodes < Fog::Collection

        model Fog::Compute::Libvirt::Node

        def all(filter={ })
          load(service.get_node_info)
        end

        def get
          all.first
        end

      end
    end
  end
end
