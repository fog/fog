module Fog
  module Compute
    class Vsphere
      class Real

        # REVISIT:  This is a naive implementation and not very efficient since
        # we find ALL VM's and then iterate over them looking for the managed object
        # reference id...  There should be an easier way to obtain a reference to a
        # VM using only the name or the _ref.  This request is primarily intended to
        # reload the attributes of a cloning VM which does not yet have an instance_uuid
        def find_vm_by_ref(params = {})
          list_virtual_machines.detect(lambda { raise Fog::Vsphere::Errors::NotFound }) do |vm|
            vm._ref == params[:vm_ref]
          end
        end

      end

      class Mock

        def find_vm_by_ref(params = {})
          Fog::Mock.not_implmented
        end

      end
    end
  end
end
