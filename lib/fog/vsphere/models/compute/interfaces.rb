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
              load service.list_vm_interfaces(vm.id)
            when Fog::Compute::Vsphere::Template
              load service.list_template_interfaces(vm.id)
            else
            raise 'interfaces should have vm or template'
          end
        end

        def get(id)
          requires :vm
          case vm
            when Fog::Compute::Vsphere::Server
              interface=service.get_vm_interface(vm.id, :key => id, :mac=> id, :name => id)
            when Fog::Compute::Vsphere::Template
              interface=service.get_template_interfaces(vm.id, :key => id, :mac=> id, :name => id)
            else
            raise 'interfaces should have vm or template'
          end
          if interface 
            Fog::Compute::Vsphere::Interface.new(interface) 
          else
            nil         
          end
        end
     end
    end
  end
end
