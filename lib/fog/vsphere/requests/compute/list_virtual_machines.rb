module Fog
  module Compute
    class Vsphere
      class Real
        def list_virtual_machines(options = {})
          # Listing all VM's can be quite slow and expensive.  Try and optimize
          # based on the available options we have.  These conditions are in
          # ascending order of  time to complete for large deployments.
          if options['instance_uuid'] then
            list_all_virtual_machines_by_instance_uuid(options)
          elsif options['folder'] then
            list_all_virtual_machines_in_folder(options)
          else
            list_all_virtual_machines
          end
        end

        private

        def list_all_virtual_machines_in_folder(options = {})
          # Tap gets rid of the leading empty string and "Datacenters" element
          # and returns the array.
          path_elements = options['folder'].split('/').tap { |ary| ary.shift 2 }
          # The DC name itself.
          dc_name = path_elements.shift
          # If the first path element contains "vm" this denotes the vmFolder
          # and needs to be shifted out since each DC contains only one
          # vmFolder
          path_elements.shift if path_elements[0] == 'vm'
          # Make sure @datacenters is populated (the keys are DataCenter instances)
          self.datacenters.include? dc_name or raise ArgumentError, "Could not find a Datacenter named #{dc_name}"
          # Get the datacenter managed object
          dc = @datacenters[dc_name]

          # Get the VM Folder (Group) efficiently
          vm_folder = dc.vmFolder

          # Walk the tree resetting the folder pointer as we go
          folder = path_elements.inject(vm_folder) do |current_folder, sub_folder_name|
            # JJM VIM::Folder#find appears to be quite efficient as it uses the
            # searchIndex It certainly appears to be faster than
            # VIM::Folder#inventory since that returns _all_ managed objects of
            # a certain type _and_ their properties.
            sub_folder = current_folder.find(sub_folder_name, RbVmomi::VIM::Folder)
            raise ArgumentError, "Could not descend into #{sub_folder_name}.  Please check your path." unless sub_folder
            sub_folder
          end

          # This should be efficient since we're not obtaining properties
          virtual_machines = folder.children.inject([]) do |ary, child|
            if child.is_a? RbVmomi::VIM::VirtualMachine then
              ary << convert_vm_mob_ref_to_attr_hash(child)
            end
            ary
          end

          # Return the managed objects themselves as an array.  These may be converted
          # to an attribute has using convert_vm_mob_ref_to_attr_hash
          { 'virtual_machines' => virtual_machines }
        end

        def list_all_virtual_machines_by_instance_uuid(options = {})
          uuid = options['instance_uuid']
          search_filter = { :uuid => uuid, 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          if vm_attribute_hash = convert_vm_mob_ref_to_attr_hash(vm_mob_ref) then
            virtual_machines = [ vm_attribute_hash ]
          else
            virtual_machines = [ ]
          end
          { 'virtual_machines' => virtual_machines }
        end

        def list_all_virtual_machines
          virtual_machines = list_all_virtual_machine_mobs.collect do |vm_mob|
            convert_vm_mob_ref_to_attr_hash(vm_mob)
          end
          { 'virtual_machines' => virtual_machines }
        end


        # NOTE: This is a private instance method required by the vm_clone
        # request.  It's very hard to get the Managed Object Reference
        # of a Template because we can't search for it by instance_uuid
        # As a result, we need a list of all virtual machines, and we
        # need them in "native" format, not filter attribute format.
        def list_all_virtual_machine_mobs
          virtual_machines = Array.new
          # Find each datacenter
          datacenters = @connection.rootFolder.children.find_all do |child|
            child.kind_of? RbVmomi::VIM::Datacenter
          end
          # Next, search the "vmFolder" inventory of each data center:
          datacenters.each do |dc|
            inventory = dc.vmFolder.inventory( 'VirtualMachine' => :all )
            virtual_machines << find_all_in_inventory(inventory, :type => RbVmomi::VIM::VirtualMachine, :property => 'name' )
          end

          virtual_machines.flatten
        end

        def find_all_in_inventory(inventory, properties = { :type => RbVmomi::VIM::VirtualMachine, :property => nil } )
          results = Array.new

          inventory.each do |k,v|

            # If we have a VMware folder we need to traverse the directory
            # to ensure we pick VMs inside folders. So we do a bit of recursion
            # here.
            results << find_all_in_inventory(v) if k.is_a? RbVmomi::VIM::Folder

            if v[0].is_a? properties[:type]
              if properties[:property].nil?
                results << v[0]
              else
                results << v[1][properties[:property]]
              end
            end
          end
          results.flatten
        end

        def get_folder_path(folder, root = nil)
          if ( not folder.methods.include?('parent') ) or ( folder == root )
            return
          end
          "#{get_folder_path(folder.parent)}/#{folder.name}"
        end
      end

      class Mock

        def get_folder_path(folder, root = nil)
          nil
        end

        def list_virtual_machines(options = {})
          case options['instance_uuid']
          when nil
            rval = YAML.load <<-'ENDvmLISTING'
---
virtual_machines:
- name: centos56gm
  hypervisor: gunab.puppetlabs.lan
  tools_version: guestToolsCurrent
  ipaddress:
  mo_ref: vm-698
  power_state: poweredOff
  uuid: 42322347-d791-cd34-80b9-e25fe28ad37c
  is_a_template: true
  id: 50323f93-6835-1178-8b8f-9e2109890e1a
  tools_state: toolsNotRunning
  connection_state: connected
  instance_uuid: 50323f93-6835-1178-8b8f-9e2109890e1a
  hostname:
  mac_addresses:
    Network adapter 1: 00:50:56:b2:00:a1
  operatingsystem:
- name: centos56gm2
  hypervisor: gunab.puppetlabs.lan
  tools_version: guestToolsCurrent
  ipaddress:
  mo_ref: vm-640
  power_state: poweredOff
  uuid: 564ddcbe-853a-d29a-b329-a0a3693a004d
  is_a_template: true
  id: 5257dee8-050c-cbcd-ae25-db0e582ab530
  tools_state: toolsNotRunning
  connection_state: connected
  instance_uuid: 5257dee8-050c-cbcd-ae25-db0e582ab530
  hostname:
  mac_addresses:
    Network adapter 1: 00:0c:29:3a:00:4d
  operatingsystem:
- name: dashboard_gm
  hypervisor: gunab.puppetlabs.lan
  tools_version: guestToolsCurrent
  ipaddress: 192.168.100.184
  mo_ref: vm-669
  power_state: poweredOn
  uuid: 564d3f91-3452-a509-a678-1246f7897979
  is_a_template: false
  id: 5032739c-c871-c0d2-034f-9700a0b5383e
  tools_state: toolsOk
  connection_state: connected
  instance_uuid: 5032739c-c871-c0d2-034f-9700a0b5383e
  hostname: compliance.puppetlabs.vm
  mac_addresses:
    Network adapter 1: 00:50:56:b2:00:96
  operatingsystem: Red Hat Enterprise Linux 6 (64-bit)
- name: jefftest
  hypervisor: gunab.puppetlabs.lan
  tools_version: guestToolsCurrent
  ipaddress: 192.168.100.187
  mo_ref: vm-715
  power_state: poweredOn
  uuid: 42329da7-e8ab-29ec-1892-d6a4a964912a
  is_a_template: false
  id: 5032c8a5-9c5e-ba7a-3804-832a03e16381
  tools_state: toolsOk
  connection_state: connected
  instance_uuid: 5032c8a5-9c5e-ba7a-3804-832a03e16381
  hostname: centos56gm.localdomain
  mac_addresses:
    Network adapter 1: 00:50:56:b2:00:af
  operatingsystem: CentOS 4/5 (32-bit)
ENDvmLISTING
          when '5032c8a5-9c5e-ba7a-3804-832a03e16381'
            YAML.load <<-'5032c8a5-9c5e-ba7a-3804-832a03e16381'
---
virtual_machines:
- name: jefftest
  hypervisor: gunab.puppetlabs.lan
  tools_version: guestToolsCurrent
  ipaddress: 192.168.100.187
  mo_ref: vm-715
  power_state: poweredOn
  uuid: 42329da7-e8ab-29ec-1892-d6a4a964912a
  is_a_template: false
  id: 5032c8a5-9c5e-ba7a-3804-832a03e16381
  tools_state: toolsOk
  connection_state: connected
  instance_uuid: 5032c8a5-9c5e-ba7a-3804-832a03e16381
  hostname: centos56gm.localdomain
  mac_addresses:
    Network adapter 1: 00:50:56:b2:00:af
  operatingsystem: CentOS 4/5 (32-bit)
            5032c8a5-9c5e-ba7a-3804-832a03e16381
          when 'does-not-exist-and-is-not-a-uuid', '50323f93-6835-1178-8b8f-9e2109890e1a'
            { 'virtual_machines' => [] }
          end
        end
      end
    end
  end
end
