module Fog
  module Compute
    class Vsphere

      module Shared

        # REVISIT:  This is a naive implementation and not very efficient since
        # we find ALL VM's and then iterate over them looking for the managed object
        # reference id...  There should be an easier way to obtain a reference to a
        # VM using only the name or the _ref.  This request is primarily intended to
        # reload the attributes of a cloning VM which does not yet have an instance_uuid
        def find_vm_by_ref(options = {})
          raise ArgumentError, "Must pass a vm_ref option" unless options['vm_ref']

          # This is the inefficient call
          all_vm_attributes = list_virtual_machines['virtual_machines']
          # Find the VM attributes of the reference
          if vm_attributes = all_vm_attributes.find { |vm| vm['mo_ref'] == options['vm_ref'] }
            response = { 'virtual_machine' => vm_attributes }
          else
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine with Managed Object Reference #{options['vm_ref']} could not be found."
          end
          response
        end

      end

      # The Real and Mock classes share the same method
      # because list_virtual_machines will be properly mocked for us

      class Real
        include Shared
      end

      class Mock
        include Shared
      end

    end
  end
end
