require 'fog/core/collection'
require 'fog/vsphere/models/compute/customvalue'

module Fog
  module Compute
    class Vsphere
      class Customvalues < Fog::Collection
        model Fog::Compute::Vsphere::Customvalue

        attr_accessor :vm

        def all(filters = {})
          requires :vm
          case vm
            when Fog::Compute::Vsphere::Server
              load service.list_vm_customvalues(vm.id)
            else
            raise 'customvalues should have vm'
          end
        end

        def get(key)
          requires :vm
          case vm
            when Fog::Compute::Vsphere::Server
              load service.list_vm_customvalues(vm.id)
            else
            raise 'customvalues should have vm'
          end.find { | cv | cv.key == key }
        end
     end
    end
  end
end
