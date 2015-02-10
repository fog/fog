require 'fog/core/collection'
require 'fog/ovirt/models/compute/volume'

module Fog
  module Compute
    class Ovirt
      class Volumes < Fog::Collection
        model Fog::Compute::Ovirt::Volume

        attr_accessor :vm

        def all(filters = {})
          if vm.is_a? Fog::Compute::Ovirt::Server
            load service.list_vm_volumes(vm.id)
          elsif vm.is_a? Fog::Compute::Ovirt::Template
            load service.list_template_volumes(vm.id)
          else
            load service.list_volumes
          end
        end

        def get(id)
          new service.get_volume(id)
        end
     end
    end
  end
end
