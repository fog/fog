module Fog
  module Compute
    class Vsphere
      class Real

        def vm_clone(params = {})
          params = { :force => false }.merge(params)
          required_params = %w{ instance_uuid name }
          required_params.each do |param|
            raise ArgumentError, "#{required_params.join(', ')} are required" unless params.has_key? param.to_sym
          end
          # First, figure out if there's already a VM of the same name.
          if not params[:force] and list_virtual_machines.detect { |vm| vm.name == params[:name] } then
            raise Fog::Vsphere::Errors::ServiceError, "A VM already exists with name #{params[:name]}"
          end
          # Find the Managed Object reference of the template VM
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
          # REVISIT: The task object contains a reference to the template but does
          # not appear to contain a reference to the newly created VM.
          # This is a really naive way to find the managed object reference
          # of the newly created VM.
          tries = 0
          new_vm = begin
            list_virtual_machines.detect(lambda { raise Fog::Vsphere::Errors::NotFound }) do |vm|
              next false if vm.name != params[:name]
              begin
                vm.config ? true : false
              rescue RuntimeError
                # This rescue is here because we want to make sure we find
                # a VM _without_ a config, which indicates the VM is still cloning.
                true
              end
            end
          rescue Fog::Vsphere::Errors::NotFound
            tries += 1
            if tries <= 10 then
              sleep 2
              retry
            end
            nil
          end
          # Taking a hint from wait_for we return a hash to indicate this is a
          # managed object reference
          {
            :vm_ref => new_vm ? new_vm._ref : nil,
            :task_ref => task._ref
          }
        end

      end

      class Mock

        def vm_clone(params = {})
          {
            :vm_ref => 'vm-123',
            :task_ref => 'task-1234'
          }
        end

      end
    end
  end
end
