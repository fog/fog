module Fog
  module Compute
    class Vsphere

      module Shared
        private
        def create_disk_config_spec(datastore, file_name, controller_key, space, options = {})
          raise ArgumentError, "Must pass parameter: datastore, file_name, controller_key, and space" unless datastore && file_name && controller_key && space

          backing_info = RbVmomi::VIM::VirtualDiskFlatVer2BackingInfo.new
          backing_info.datastore = datastore
          if options[:independent]
            backing_info.diskMode = RbVmomi::VIM::VirtualDiskMode("independent_nonpersistent")
          else
            backing_info.diskMode = RbVmomi::VIM::VirtualDiskMode("persistent")
          end
          backing_info.fileName = file_name
          #puts backing_info.to_s
          #puts "end1"

          virtual_disk = RbVmomi::VIM::VirtualDisk.new #VirtualDisk
          virtual_disk.key = -1
          virtual_disk.controllerKey = controller_key
          virtual_disk.backing = backing_info
          virtual_disk.capacityInKB = space * 1024
          #puts virtual_disk.to_s
          #puts "end2"

          device_config_spec = RbVmomi::VIM::VirtualDeviceConfigSpec.new   #VirtualDeviceConfigSpec
          device_config_spec.device = virtual_disk
          device_config_spec.operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation("add")
          if options[:create]
            device_config_spec.fileOperation = RbVmomi::VIM::VirtualDeviceConfigSpecFileOperation("create")
          end
          device_config_spec
        end

        def fix_device_unit_numbers(devices, device_changes)
          max_unit_numbers = {}
          devices.each do |device|
            if device.controllerKey
              max_unit_number = max_unit_numbers[device.controllerKey]
              if max_unit_number.nil? || max_unit_number < device.unitNumber
                max_unit_numbers[device.controllerKey] = device.unitNumber
              end
            end
          end

          device_changes.each do |device_change|
            device = device_change.device
            if device.controllerKey && device.unitNumber.nil?
              max_unit_number = max_unit_numbers[device.controllerKey] || 0
              device.unitNumber = max_unit_number + 1
              max_unit_numbers[device.controllerKey] = device.unitNumber
            end
          end
        end

      end

      class Real
        include Shared
        def get_ds_name_by_path(vmdk_path)
          path_elements = vmdk_path.split('[').tap { |ary| ary.shift }
          template_ds = path_elements.shift
          template_ds = template_ds.split(']')
          datastore_name = template_ds[0]
          datastore_name
        end

        def vm_create_disk (options = {})
          raise ArgumentError, "Must pass options: vm_moid or instance_uuid, vmdk_path, and disk_size" unless (options['vm_moid'] || options['instance_uuid']) && options['vmdk_path'] && options['disk_size']

          if options['vm_moid']
            vm_mob_ref = get_vm_mob_by_id(options['vm_moid'])
          end

          if options['instance_uuid']
            search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
            vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          end

          dc_mob_ref = vm_mob_ref.parent.parent

          ds_name = get_ds_name_by_path(options['vmdk_path'])
          datastore_mob_ref = dc_mob_ref.find_datastore(ds_name)
          #puts datastore_mob_ref #Datastore("datastore-460")

          devices = vm_mob_ref.config.hardware.device
          system_disk = devices.select do |vm_device|
            vm_device.class == RbVmomi::VIM::VirtualDisk
          end #1000

          disk_config = create_disk_config_spec(datastore_mob_ref, options['vmdk_path'],
                                                system_disk[0].controllerKey, options['disk_size'].to_i,
                                                :create => true, :independent => true)

          config = RbVmomi::VIM::VirtualMachineConfigSpec.new
          config.deviceChange = []
          config.deviceChange << disk_config
          fix_device_unit_numbers(devices, config.deviceChange)

          task = vm_mob_ref.ReconfigVM_Task(:spec => config)
          task.wait_for_completion

          {
              'vm_ref'        => vm_mob_ref,
              'vm_attributes' => convert_vm_mob_ref_to_attr_hash(vm_mob_ref),
              'vm_dev_number_increase' =>  (vm_mob_ref.config.hardware.device.size - devices.size),
              'task_state' => task.info.state
          }

        end

      end

      class Mock
        include Shared
        def vm_clone(options = {})
          # Option handling
          options = vm_fine_clone_check_options(options)
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Cloud not find VM template" }
          vm_mob_ref = list_virtual_machines['virtual_machines'].find(notfound) do |vm|
            vm['name'] == options['path'].split("/")[-1]
          end
          {
              'vm_ref'   => 'vm-123',
              'task_ref' => 'task-1234',
          }
        end

      end
    end
  end
end
