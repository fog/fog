# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
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

module Fog
  module Compute
    class Vsphere

      class Real
        include Shared

        def vm_update_network(options = {})
          raise ArgumentError, "Must pass parameter: vm_moid or instance_uuid" unless (options['vm_moid'] || options['instance_uuid'])
          raise ArgumentError, "Cannot specify both vm_moid and instance_uuid" if (options['vm_moid'] && options['instance_uuid'])
          raise ArgumentError, "Must pass parameter: network adapter name" unless options['adapter_name']
          raise ArgumentError, "Must pass parameter: portgroup name" unless options['portgroup_name']

          if options['vm_moid']
            vm_mob_ref = get_vm_mob_ref_by_moid(options['vm_moid'])
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine #{options['vm_moid']} not found." unless vm_mob_ref
          end

          if options['instance_uuid']
            search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
            vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine #{options['instance_uuid']} not found." unless vm_mob_ref
          end

          devices = vm_mob_ref.config.hardware.device
          nic = devices.select { |device| device.kind_of?(RbVmomi::VIM::VirtualEthernetCard) &&
              device.deviceInfo.label == options['adapter_name'] }.first
          raise Fog::Compute::Vsphere::NotFound, "network adapter:#{options['adapter_name']} not found." unless nic

          dc_mob_ref = get_parent_dc_by_vm_mob(vm_mob_ref)
          network_mob_ref = get_portgroups_by_dc_mob(dc_mob_ref).fetch(options['portgroup_name'])
          raise Fog::Compute::Vsphere::NotFound, "portgroup:#{options['portgroup']} not found." unless network_mob_ref

          if network_mob_ref.class == RbVmomi::VIM::DistributedVirtualPortgroup
            port = RbVmomi::VIM::DistributedVirtualSwitchPortConnection.new
            port.switchUuid = network_mob_ref.config.distributedVirtualSwitch.uuid
            port.portgroupKey = network_mob_ref.config.key

            backing_info = RbVmomi::VIM::VirtualEthernetCardDistributedVirtualPortBackingInfo.new
            backing_info.port = port
          else
            backing_info = RbVmomi::VIM::VirtualEthernetCardNetworkBackingInfo.new
            backing_info.deviceName = options['portgroup_name']
            backing_info.network = network_mob_ref
          end

          nic.backing = backing_info
          network_config_spec = RbVmomi::VIM::VirtualDeviceConfigSpec.new
          network_config_spec.device = nic
          if options['remove']
            network_config_spec.operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation("remove")
          else
            network_config_spec.operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation("edit")
          end

          config = RbVmomi::VIM::VirtualMachineConfigSpec.new
          config.deviceChange = []
          config.deviceChange << network_config_spec

          task = vm_mob_ref.ReconfigVM_Task(:spec => config)
          wait_for_task(task)

          {
              'vm_ref'        => vm_mob_ref,
              'vm_attributes' => convert_vm_mob_ref_to_attr_hash(vm_mob_ref),
              'task_state' => task.info.state
          }

        end

      end

      class Mock
        def vm_update_network(options = {})
          raise ArgumentError, "Must pass parameter: vm_moid or instance_uuid" unless (options['vm_moid'] || options['instance_uuid'])
          raise ArgumentError, "Cannot specify both vm_moid and instance_uuid" if (options['vm_moid'] && options['instance_uuid'])
          raise ArgumentError, "Must pass parameter: network adapter name" unless options['adapter_name']
          raise ArgumentError, "Must pass parameter: portgroup name" unless options['portgroup_name']
          {
              'vm_ref'   => 'vm-123',
              'task_ref' => 'task-1234',
          }
        end

      end
    end
  end
end
