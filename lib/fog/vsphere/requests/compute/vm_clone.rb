module Fog
  module Compute
    class Vsphere
      class Real

        def vm_clone(params = {})
          raise ArgumentError, ":instance_uuid and :name are required" if params.empty?
          # First, find the Managed Object of the template VM
          vm = find_template_by_instance_uuid(params[:instance_uuid])
          # We need to locate the datacenter object to find the
          # default resource pool.
          container = vm.parent
          until container.kind_of? RbVmomi::VIM::Datacenter
            container = container.parent
          end
          dc = container
          # With the Datacenter Object we can obtain the resource pool
          resource_pool = dc.hostFolder.children.first.resourcePool
          # Next, create a Relocation Spec instance
          relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:pool => resource_pool,
                                                                    :transform => 'sparse')
          # And the clone specification
          clone_spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocation_spec,
                                                            :powerOn  => true,
                                                            :template => false)
          task = vm.CloneVM_Task(:folder => vm.parent, :name => params[:name], :spec => clone_spec)
          # REVISIT: We may want to return an identifier for the asyncronous task
          task.info.state
        end

      end

      class Mock

        def vm_clone(params = {})
          "running"
        end

      end
    end
  end
end
