module Fog
  module Compute
    class Vsphere

      module Shared
        private
        def create_disk_config_spec(datastore, file_name, controller_key, space, options = {})
          raise ArgumentError, "Must pass parameter: datastore" unless datastore
          raise ArgumentError, "Must pass parameter: file_name" unless file_name
          raise ArgumentError, "Must pass parameter: controller_key" unless controller_key
          raise ArgumentError, "Must pass parameter: space" unless space

          backing_info = RbVmomi::VIM::VirtualDiskFlatVer2BackingInfo.new
          backing_info.datastore = datastore
          if options[:independent]
            backing_info.diskMode = RbVmomi::VIM::VirtualDiskMode("independent_persistent")
          else
            backing_info.diskMode = RbVmomi::VIM::VirtualDiskMode("persistent")
          end
          backing_info.fileName = file_name

          virtual_disk = RbVmomi::VIM::VirtualDisk.new #VirtualDisk
          virtual_disk.key = -1
          virtual_disk.controllerKey = controller_key
          virtual_disk.backing = backing_info
          virtual_disk.capacityInKB = space * 1024

          device_config_spec = RbVmomi::VIM::VirtualDeviceConfigSpec.new
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

        def get_parent_dc_by_vm_mob(vm_mob_ref, options = {})
          mob_ref = vm_mob_ref.parent
          while !(mob_ref.kind_of? RbVmomi::VIM::Datacenter)
            mob_ref = mob_ref.parent
          end
          mob_ref
        end

        def vm_create_disk (options = {})
          raise ArgumentError, "Must pass parameter: vm_moid or instance_uuid" unless (options['vm_moid'] || options['instance_uuid'])
          raise ArgumentError, "Must pass parameter: vmdk_path" unless options['vmdk_path']
          raise ArgumentError, "Must pass parameter: disk_size" unless options['disk_size']

          if options['vm_moid']
            vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
          end

          if options['instance_uuid']
            search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
            vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
            if vm_mob_ref
              if options['vm_moid'] && ( vm_mob_ref._ref.to_s != options['vm_moid'])
                raise ArgumentError, "Passed vm_moid and instance_uuid should refer to the same vm management object"
              end
            else
              raise Fog::Compute::Vsphere::NotFound, "VirtualMachine with Managed Object Reference #{options['instance_uuid']} could not be found."
            end
          end

          dc_mob_ref = get_parent_dc_by_vm_mob(vm_mob_ref)
          ds_name = get_ds_name_by_path(options['vmdk_path'])
          datastore_mob_ref = dc_mob_ref.find_datastore(ds_name)

          devices = vm_mob_ref.config.hardware.device
          system_disk = devices.select { |vm_device| vm_device.class == RbVmomi::VIM::VirtualDisk }

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
        def vm_create_disk(options = {})
          {
              "vm_ref"=>VirtualMachine("vm-471"),
              "vm_attributes"=>{
                  "id"=>"5001a218-732b-2f5c-e8a7-e0599f2900bb",
                  "name"=>"knife",
                  "uuid"=>"4201b032-7a6d-03da-488d-e09f16da0db5",
                  "instance_uuid"=>"5001a218-732b-2f5c-e8a7-e0599f2900bb",
                  "hostname"=>nil,
                  "operatingsystem"=>nil,
                  "ipaddress"=>nil,
                  "power_state"=>"poweredOn",
                  "connection_state"=>"connected",
                  "hypervisor"=>"10.117.8.187",
                  "tools_state"=>"toolsNotInstalled",
                  "tools_version"=>"guestToolsNotInstalled",
                  "is_a_template"=>false,
                  "memory_mb"=>512,
                  "cpus"=>1,
                  "mo_ref"=>"vm-471",
                  "mac_addresses"=>{
                      "Network adapter1"=>"00:50:56:81:01:8e"
                  },
                  "path"=>nil
              },
              "vm_dev_number_increase"=>1,
              "task_state"=>"success"
          }
        end

      end
    end
  end
end
