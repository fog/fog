module Fog
  module Compute
    class Vsphere
      class Real

        def vm_relocate(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          # Find the VM Object
          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          if options['host_system'] &&  options['datacenter']
            host_system = get_host_system(options['host_system'], options['datacenter'])
            resource_pool = get_raw_resource_pool2(options['host_system'], options['datacenter'])
          end
          datastore = get_raw_datastore(options['datastore'], options['datacenter']) if options['datastore'] &&  options['datacenter']
          datastore = host_system.datastore.first if host_system && !datastore
          
          relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => datastore,
                                                                :host=>host_system,
                                                                :pool => resource_pool)

          unless vm_mob_ref.kind_of? RbVmomi::VIM::VirtualMachine
            raise Fog::Vsphere::Errors::NotFound,
              "Could not find VirtualMachine with instance uuid #{options['instance_uuid']}"
          end
          task = vm_mob_ref.RelocateVM_Task(:spec => relocation_spec)
          task.wait_for_completion
        end

      end

      class Mock

        def vm_relocate(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          raise ArgumentError, "spec is a required parameter" unless options.has_key? 'spec'
        end

      end
    end
  end
end
