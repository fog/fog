module Fog
  module Compute
    class Vsphere
      class Real
        def list_virtual_machines(options = { })
          # Listing all VM's can be quite slow and expensive.  Try and optimize
          # based on the available options we have.  These conditions are in
          # ascending order of time to complete for large deployments.

          options[:folder] ||= options['folder']
          if options['instance_uuid'] then
            [connection.get_virtual_machine(options['instance_uuid'])]
          elsif options[:folder] && options[:datacenter] then
            list_all_virtual_machines_in_folder(options[:folder], options[:datacenter])
          else
            list_all_virtual_machines(options)
          end
        end

        private

        def list_all_virtual_machines_in_folder(path, datacenter_name)
          folder = get_raw_vmfolder(path, datacenter_name)

          folder.children.grep(RbVmomi::VIM::VirtualMachine).map(&method(:convert_vm_mob_ref_to_attr_hash))
        end

        def list_all_virtual_machines(options = { })
          datacenters = find_datacenters(options[:datacenter])
          # TODO: go though nested folders
          vms         = datacenters.map { |dc| dc.vmFolder.childEntity.grep(RbVmomi::VIM::VirtualMachine) }.flatten
          # remove all template based virtual machines
          vms.delete_if { |v| v.config.template }

          vms.map do |vm_mob|
            convert_vm_mob_ref_to_attr_hash(vm_mob)
          end
        end

        def get_folder_path(folder, root = nil)
          if (not folder.methods.include?('parent')) or (folder == root)
            return
          end
          "#{get_folder_path(folder.parent)}/#{folder.name}"
        end
      end

      class Mock

        def get_folder_path(folder, root = nil)
          nil
        end

        def list_virtual_machines(options = { })
          case options['instance_uuid']
            when nil

              [
                { :resource_pool    => "Resources",
                  :memory_mb        => 2196,
                  :mac_addresses    => { "Network adapter 1" => "00:50:56:a9:00:28" },
                  :power_state      => "poweredOn",
                  :cpus             => 1,
                  :hostname         => "dhcp75-197.virt.bos.redhat.com",
                  :mo_ref           => "vm-562",
                  :connection_state => "connected",
                  :overall_status   => "green",
                  :datacenter       => "Solutions",
                  :volumes          =>
                    [{
                       :id        => "6000C29c-a47d-4cd9-5249-c371de775f06",
                       :datastore => "Storage1",
                       :mode      => "persistent",
                       :size      => 8388608,
                       :thin      => true,
                       :name      => "Hard disk 1",
                       :filename  => "[Storage1] rhel6-mfojtik/rhel6-mfojtik.vmdk",
                       :size_gb   => 8
                     }],
                  :interfaces       =>
                    [{ :mac     => "00:50:56:a9:00:28",
                       :network => "VM Network",
                       :name    => "Network adapter 1",
                       :status  => "ok",
                       :summary => "VM Network",
                     }],
                  :hypervisor       => "gunab.puppetlabs.lan",
                  :guest_id         => "rhel6_64Guest",
                  :tools_state      => "toolsOk",
                  :cluster          => "Solutionscluster",
                  :name             => "rhel64",
                  :operatingsystem  => "Red Hat Enterprise Linux 6 (64-bit)",
                  :uuid             => "4229f0e9-bfdc-d9a7-7bac-12070772e6dc",
                  :path             => "/Datacenters/Solutions/vm",
                  :id               => "5029c440-85ee-c2a1-e9dd-b63e39364603",
                  :tools_version    => "guestToolsUnmanaged",
                  :ipaddress        => "192.168.100.184",
                },
                { :resource_pool    => "Resources",
                  :memory_mb        => 512,
                  :power_state      => "poweredOn",
                  :mac_addresses    => { "Network adapter 1" => "00:50:56:a9:00:00" },
                  :hostname         => nil,
                  :cpus             => 1,
                  :connection_state => "connected",
                  :mo_ref           => "vm-621",
                  :overall_status   => "green",
                  :datacenter       => "Solutions",
                  :volumes          =>
                    [{ :thin      => false,
                       :size_gb   => 10,
                       :datastore => "datastore1",
                       :filename  => "[datastore1] i-1342439683/i-1342439683.vmdk",
                       :size      => 10485762,
                       :name      => "Hard disk 1",
                       :mode      => "persistent",
                       :id        => "6000C29b-f364-d073-8316-8e98ac0a0eae" }],
                  :interfaces       =>
                    [{  :summary => "VM Network",
                       :mac     => "00:50:56:a9:00:00",
                       :status  => "ok",
                       :network => "VM Network",
                       :name    => "Network adapter 1" }],
                  :instance_uuid    => "502916a3-b42e-17c7-43ce-b3206e9524dc",
                  :hypervisor       => "gunab.puppetlabs.lan",
                  :guest_id         => nil,
                  :cluster          => "Solutionscluster",
                  :tools_state      => "toolsNotInstalled",
                  :uuid             => "4229e0de-30cb-ceb2-21f9-4d8d8beabb52",
                  :name             => "i-1342439683",
                  :operatingsystem  => nil,
                  :path             => "/",
                  :tools_version    => "guestToolsNotInstalled",
                  :id               => "502916a3-b42e-17c7-43ce-b3206e9524dc",
                  :ipaddress        => nil }


              ]
            when '5032c8a5-9c5e-ba7a-3804-832a03e16381'
              [{ :resource_pool    => "Resources",
                 :memory_mb        => 2196,
                 :power_state      => "poweredOn",
                 :mac_addresses    => { "Network adapter 1" => "00:50:56:b2:00:af" },
                 :hostname         => "centos56gm.localdomain",
                 :cpus             => 1,
                 :connection_state => "connected",
                 :mo_ref           => "vm-715",
                 :overall_status   => "green",
                 :datacenter       => "Solutions",
                 :instance_uuid    => "5029c440-85ee-c2a1-e9dd-b63e39364603",
                 :hypervisor       => "gunab.puppetlabs.lan",
                 :guest_id         => "rhel6_64Guest",
                 :cluster          => "Solutionscluster",
                 :tools_state      => "toolsOk",
                 :name             => "jefftest",
                 :operatingsystem  => "Red Hat Enterprise Linux 6 (64-bit)",
                 :path             => "/",
                 :tools_version    => "guestToolsUnmanaged",
                 :ipaddress        => "192.168.100.187",
                 :id               => "5032c8a5-9c5e-ba7a-3804-832a03e16381",
                 :uuid             => "42329da7-e8ab-29ec-1892-d6a4a964912a"

               }

              ]
            when 'does-not-exist-and-is-not-a-uuid', '50323f93-6835-1178-8b8f-9e2109890e1a'
              []
          end
        end
      end
    end
  end
end
