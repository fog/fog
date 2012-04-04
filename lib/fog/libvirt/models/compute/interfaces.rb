require 'fog/core/collection'
require 'fog/libvirt/models/compute/interface'

module Fog
  module Compute
    class Libvirt

      class Interfaces < Fog::Collection

        model Fog::Compute::Libvirt::Interface

        def all(filter={})
          load(connection.list_interfaces(filter))
        end

        def get(name)
          self.all(:name => name).first
        end

      end

    end
  end
end
