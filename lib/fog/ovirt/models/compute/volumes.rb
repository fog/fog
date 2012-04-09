require 'fog/core/collection'
require 'fog/ovirt/models/compute/volume'

module Fog
  module Compute
    class Ovirt

      class Volumes < Fog::Collection

        model Fog::Compute::Ovirt::Volume

        attr_accessor :vm

        def all(filters = {})
          requires :vm
          if vm.is_a? Fog::Compute::Ovirt::Server
            load connection.list_vm_volumes(vm.id)
          elsif vm.is_a? Fog::Compute::Ovirt::Template
            load connection.list_template_volumes(vm.id)
          else
            raise 'volumes should have vm or template'
          end
        end

        def get(id)
          new connection.get_volume(id)
        end

     end
    end
  end
end
