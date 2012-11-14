require 'fog/core/collection'
require 'fog/vsphere/models/compute/interface'

module Fog
  module Compute
    class Vsphere

      class Interfaces < Fog::Collection

        model Fog::Compute::Vsphere::Interface

        attr_accessor :vm

        def all(filters = {})
          requires :vm
          case vm
            when Fog::Compute::Vsphere::Server
              load connection.list_vm_interfaces(vm.id)
            when Fog::Compute::Vsphere::Template
              load connection.list_template_interfaces(vm.id)
            else
            raise 'interfaces should have vm or template'
          end
        end

        def get(id)
          new connection.get_interface(id)
        end

     end
    end
  end
end
