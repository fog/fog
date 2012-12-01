module Fog
  module Compute
    class Vsphere
      class Real
        def get_virtual_machine(id, datacenter_name = nil)
          convert_vm_mob_ref_to_attr_hash(get_vm_ref(id, datacenter_name))
        end

        protected

        def get_vm_ref(id, dc = nil)
          vm = case id
                 # UUID based
                 when /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/
                   @connection.searchIndex.FindByUuid :uuid => id, :vmSearch => true, :instanceUuid => true, :datacenter => dc
                 else
                   # try to find based on VM name
                   if dc
                     get_raw_datacenter(dc).find_vm(id)
                   else
                     raw_datacenters.map { |d| d.find_vm(id) }.compact.first
                   end
               end
          vm ? vm : raise(Fog::Compute::Vsphere::NotFound, "#{id} was not found")
        end
      end

      class Mock
        def get_virtual_machine(id, datacenter_name = nil)
          case id
          when "5032c8a5-9c5e-ba7a-3804-832a03e16381", 'vm-715'
            { :resource_pool    => "Resources",
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
              :cluster          => "virtlabcluster",
              :tools_state      => "toolsOk",
              :name             => "jefftest",
              :operatingsystem  => "Red Hat Enterprise Linux 6 (64-bit)",
              :path             => "/",
              :tools_version    => "guestToolsUnmanaged",
              :ipaddress        => "192.168.100.187",
              :id               => "5032c8a5-9c5e-ba7a-3804-832a03e16381",
              :uuid             => "42329da7-e8ab-29ec-1892-d6a4a964912a"
            }
          end
        end

      end

    end
  end
end
