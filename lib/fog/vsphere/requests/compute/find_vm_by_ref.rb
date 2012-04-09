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

        def get_vm_mob_ref_by_path (options = {})
          raise ArgumentError, "Must pass a path option" unless options['path']
          path_elements = options['path'].split('/').tap { |ary| ary.shift 2 }
          # The DC name itself.
          template_dc = path_elements.shift
          # If the first path element contains "vm" this denotes the vmFolder
          # and needs to be shifted out
          path_elements.shift if path_elements[0] == 'vm'
          # The template name.  The remaining elements are the folders in the
          # datacenter.
          template_name = path_elements.pop
          dc_mob_ref = get_dc_mob_ref_by_path(template_dc)
          vm_mob_ref = dc_mob_ref.find_vm(template_name)
          vm_mob_ref
        end

        def get_vm_mob_ref_by_moid(vm_moid)
          raise ArgumentError, "Must pass a vm management object id" unless vm_moid
          vm_mob_ref = RbVmomi::VIM::VirtualMachine.new(@connection,vm_moid)
          vm_mob_ref
        end

      end # shared

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
