require 'fog/core/collection'
require 'fog/vsphere/models/compute/volume'

module Fog
  module Compute
    class Vsphere

      class Volumes < Fog::Collection

        model Fog::Compute::Vsphere::Volume

        attr_accessor :vm

        def all(filters = {})
          requires :vm
          case vm
            when Fog::Compute::Vsphere::Server
              load service.list_vm_volumes(vm.id)
            when Fog::Compute::Vsphere::Template
              load service.list_template_volumes(vm.id)
            else
              raise 'volumes should have vm or template'
          end
        end

        def get(id)
          new service.get_volume(id)
        end

     end
    end
  end
end
