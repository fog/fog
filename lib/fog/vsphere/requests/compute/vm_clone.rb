module Fog
  module Compute
    class Vsphere

      module Shared
        private
        def vm_clone_check_options(options)
          options = { 'force' => false }.merge(options)
          required_options = %w{ instance_uuid name }
          required_options.each do |param|
            raise ArgumentError, "#{required_options.join(', ')} are required" unless options.has_key? param
          end
          # First, figure out if there's already a VM of the same name.
          all_virtual_machines = list_virtual_machines['virtual_machines']
          if not options['force'] and all_virtual_machines.detect { |vm| vm['name'] == options['name'] } then
            raise Fog::Vsphere::Errors::ServiceError, "A VM already exists with name #{options['name']}"
          end
          options
        end
      end

      class Real
        include Shared
        def vm_clone(options = {})
          # Option handling
          options = vm_clone_check_options(options)

          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Cloud not find VM template" }

          # REVISIT: This will have horrible performance for large sites.
          # Find the Managed Object reference of the template VM (Wish I could do this with the API)
          vm_mob_ref = list_all_virtual_machine_mobs.find(notfound) do |vm|
            convert_vm_mob_ref_to_attr_hash(vm)['instance_uuid'] == options['instance_uuid']
          end

          # We need to locate the datacenter object to find the
          # default resource pool.
          container = vm_mob_ref.parent
          until container.kind_of? RbVmomi::VIM::Datacenter
            container = container.parent
          end
          dc = container
          # With the Datacenter Object we can obtain the resource pool
          resource_pool = dc.hostFolder.children.first.resourcePool
          # Next, create a Relocation Spec instance
          relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:pool => resource_pool,
                                                                    :transform => options['transform'] || 'sparse')
          # And the clone specification
          clone_spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocation_spec,
                                                            :powerOn  => options['power_on'] || true,
                                                            :template => false)
          task = vm_mob_ref.CloneVM_Task(:folder => vm_mob_ref.parent, :name => options['name'], :spec => clone_spec)
          # REVISIT: The task object contains a reference to the template but does
          # not appear to contain a reference to the newly created VM.
          # This is a really naive way to find the managed object reference
          # of the newly created VM.
          tries = 0
          new_vm = begin
            list_virtual_machines['virtual_machines'].detect(lambda { raise Fog::Vsphere::Errors::NotFound }) do |vm|
              vm['name'] == options['name']
            end
          rescue Fog::Vsphere::Errors::NotFound
            tries += 1
            if tries <= 10 then
              sleep 1
              retry
            end
            nil
          end
          # Return hash
          {
            'vm_ref'   => new_vm ? new_vm['mo_ref'] : nil,
            'task_ref' => task._ref
          }
        end

      end

      class Mock
        include Shared
        def vm_clone(options = {})
          # Option handling
          options = vm_clone_check_options(options)
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Cloud not find VM template" }
          vm_mob_ref = list_virtual_machines['virtual_machines'].find(notfound) do |vm|
            vm['instance_uuid'] == options['instance_uuid']
          end
          {
            'vm_ref'   => 'vm-123',
            'task_ref' => 'task-1234'
          }
        end

      end
    end
  end
end
