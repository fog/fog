# Copyright (c) 2012-2013 VMware, Inc. All Rights Reserved.
#
#      Licensed under the Apache License, Version 2.0 (the "License");
#
#   you may not use this file except in compliance with the License.
#
#   You may obtain a copy of the License at
#
#
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#
#
#
#   Unless required by applicable law or agreed to in writing, software
#
#   distributed under the License is distributed on an "AS IS" BASIS,
#
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
#   See the License for the specific language governing permissions and
#
#   limitations under the License.

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'utility'))

module Fog
  module Storage
    class Vsphere

      module Shared
        include Fog::Vsphere::Utility

        # according to doc vshpere-51-configuration-maximums.pdf, the maximum number of 
        # Virtual SCSI Adapters per virtual machine is 4
        MAX_SCSI_ADAPTERS_PER_VM = 4

        def fetch_scsi_controller(vm_mob_ref, controller_type, disk_type)
          begin
            devices = vm_mob_ref.config.hardware.device
            # only support paravirtual and lsilogic types right now
            exist_para_controllers = devices.select { |vm_device| vm_device.kind_of?(RbVmomi::VIM::ParaVirtualSCSIController)}
            exist_lsi_controllers = devices.select { |vm_device| vm_device.kind_of?(RbVmomi::VIM::VirtualLsiLogicController)}
            # system disk missed
            if exist_lsi_controllers.nil?
              return
            end

            exist_controllers = exist_lsi_controllers
            exist_controllers += exist_para_controllers unless exist_para_controllers.nil?
            
            # the controller with the smallest unitNumber should be the one system_disk attached to
            sys_controller = exist_lsi_controllers[0]
            exist_lsi_controllers.each do |ctr|
              if sys_controller.unitNumber > ctr.unitNumber
                sys_controller = ctr
              end
            end

            if disk_type == 'swap'
              return sys_controller.key
            end

            if exist_controllers.size == MAX_SCSI_ADAPTERS_PER_VM
              select_controller = nil
              exist_controllers.each do |ctr|
                next if ctr == sys_controller
                if select_controller.nil? or select_controller.device.size > ctr.device.size
                  select_controller = ctr
                end
              end
              return select_controller.key
            else
              scsi_controller = nil
              if controller_type == 'paravirtual'
                scsi_controller = RbVmomi::VIM::ParaVirtualSCSIController.new
              elsif controller_type == 'lsilogic'
                scsi_controller = RbVmomi::VIM::VirtualLsiLogicController.new
              else
                return
              end
              max_unitNum = nil
              max_busNum = nil
              exist_controllers.each do |ctr|
                if max_unitNum.nil? or max_unitNum < ctr.unitNumber
                  max_unitNum = ctr.unitNumber
                  max_busNum = ctr.busNumber
                end
              end

              scsi_controller.key = -100
              scsi_controller.controllerKey = exist_controllers[0].controllerKey
              scsi_controller.unitNumber = max_unitNum + 1
              scsi_controller.busNumber = max_busNum + 1
              scsi_controller.sharedBus = RbVmomi::VIM::VirtualSCSISharing("noSharing")

              controller_config_spec = RbVmomi::VIM::VirtualDeviceConfigSpec.new
              controller_config_spec.device = scsi_controller
              controller_config_spec.operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation("add")

              config = RbVmomi::VIM::VirtualMachineConfigSpec.new
              config.deviceChange = []
              config.deviceChange << controller_config_spec

              task = vm_mob_ref.ReconfigVM_Task(:spec => config)

              wait_for_task(task)
              if task.info.state == 'success'
                devices = vm_mob_ref.config.hardware.device
                new_controller = devices.find { |vm_device| vm_device.unitNumber == max_unitNum + 1 }
                key = new_controller.key
              else
                key = nil
              end
            end
          rescue => e
            Fog::Logger.debug("fog:create_disk error #{e} happened")
          end
          return key
        end

        private

        def create_disk_config_spec(datastore, file_name, controller_key, unit_number, space, options = {})
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

          if options[:provison_type] == 'thin'
            backing_info.thinProvisioned = true
          elsif options[:privison_type] == 'thick_eager_zeroed'
            backing_info.thinProvisioned = false
            backing_info.eagerlyScrub = true
          else
            backing_info.thinProvisioned = false
            backing_info.eagerlyScrub = false
          end

          backing_info.fileName = file_name

          virtual_disk = RbVmomi::VIM::VirtualDisk.new
          virtual_disk.key = -1
          virtual_disk.controllerKey = controller_key
          virtual_disk.unitNumber = unit_number
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

        def create_delete_device_spec(device, options = {})
          device_config_spec = RbVmomi::VIM::VirtualDeviceConfigSpec.new
          device_config_spec.device = device
          device_config_spec.operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation("remove")
          if options[:destroy]
            device_config_spec.fileOperation = RbVmomi::VIM::VirtualDeviceConfigSpecFileOperation("destroy")
          end
          device_config_spec
        end

        def calculate_unit_number(devices, controller_key)
          controller = devices.find { |vm_device| vm_device.key == controller_key }
          unit_num = controller.device.size
          unit_num += 1 if unit_num >= 7
          unit_num
        end

        def fix_device_unit_numbers(devices, device_changes, system_disk_key )
          max_unit_numbers = {}
          devices.each do |device|
            if device.controllerKey
              max_unit_number = max_unit_numbers[device.controllerKey] || 0
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
              if device.unitNumber == 7
                device.unitNumber +=1
              end
              max_unit_numbers[device.controllerKey] = device.unitNumber
            end
          end
          max_unit_numbers[system_disk_key]
        end
      end

      class Real
        include Shared

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
          Fog::Logger.debug("fog:create disk transport options['transport'] = #{options['transport']} fullpath is #{options['vmdk_path']} unit_number=#{options['unit_number']}}")
          controller_key = fetch_scsi_controller(vm_mob_ref, options['transport'], options['disk_type'])
          Fog::Logger.debug("fog:transport controller_key = #{controller_key}")

          devices = vm_mob_ref.config.hardware.device
          unit_num = calculate_unit_number(devices, controller_key)

          disk_config = create_disk_config_spec(datastore_mob_ref,
                                                options['vmdk_path'],
                                                controller_key,
                                                unit_num,
                                                options['disk_size'].to_i,
                                                :create => true,
                                                :physicalMode => true,
                                                :independent => true,
                                                :provison_type => options['provison_type']
          )

          config = RbVmomi::VIM::VirtualMachineConfigSpec.new
          config.deviceChange = []
          config.deviceChange << disk_config
#          scsi_num = fix_device_unit_numbers(devices, config.deviceChange, controller_key)

          task = vm_mob_ref.ReconfigVM_Task(:spec => config)
          wait_for_task(task)

          {
              'vm_ref'        => vm_mob_ref,
              'scsi_key' => controller_key,
              'scsi_num' => unit_num,
              'vm_attributes' => convert_vm_mob_ref_to_attr_hash(vm_mob_ref),
              'vm_dev_number_increase' =>  (vm_mob_ref.config.hardware.device.size - devices.size),
              'task_state' => task.info.state
          }
        end

        def vm_delete_disk (options = {})
          raise ArgumentError, "Must pass parameter: vm_moid or instance_uuid" unless (options['vm_moid'] || options['instance_uuid'])
          raise ArgumentError, "Must pass parameter: vmdk_path" unless options['vmdk_path']

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

          devices = vm_mob_ref.config.hardware.device
          disk = devices.select { |device| device.kind_of?(RbVmomi::VIM::VirtualDisk) &&
              device.backing.fileName == options['vmdk_path'] }.first

          config = RbVmomi::VIM::VirtualMachineConfigSpec.new
          config.deviceChange = []
          config.deviceChange << create_delete_device_spec(disk, :destroy => true)

          task = vm_mob_ref.ReconfigVM_Task(:spec => config)
          wait_for_task(task)

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
