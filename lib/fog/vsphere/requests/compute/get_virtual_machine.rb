module Fog
  module Compute
    class Vsphere
      class Real
        def get_virtual_machine(id, datacenter_name = nil)
          # The larger the VM list the longer it will take if not searching based on UUID.
          convert_vm_mob_ref_to_attr_hash(get_vm_ref(id, datacenter_name))
        end

        protected

        def get_vm_ref(id, dc = nil)
          raw_datacenter = find_raw_datacenter(dc) if dc
          vm = case is_uuid?(id)
                 # UUID based
                 when true
                   params = {:uuid => id, :vmSearch => true, :instanceUuid => true}
                   params[:datacenter] = raw_datacenter if dc
                   @connection.searchIndex.FindByUuid(params)
                 else
                   # try to find based on VM name
                   if dc
                     get_vm_by_name(id, dc)
                   else
                     raw_datacenters.map { |d| get_vm_by_name(id, d["name"])}.compact.first
                   end
               end
          vm ? vm : raise(Fog::Compute::Vsphere::NotFound, "#{id} was not found")
        end

        def get_vm_by_name(name, dc)
          vms = raw_list_all_virtual_machines(dc)

         if name.include?('/')
            folder = File.dirname(name)
            basename = File.basename(name)
            vms.keep_if { |v| v["name"] == basename && v.parent.pretty_path.include?(folder) }.first
          else
            vms.keep_if { |v| v["name"] == name }.first
          end
        end
      end

      class Mock
        def get_virtual_machine(id, datacenter_name = nil)
          if is_uuid?(id)
            vm = list_virtual_machines({ 'instance_uuid' => id, 'datacenter' => datacenter_name }).first
          else
            # try to find based on VM name. May need to handle the path of the VM
            vm = list_virtual_machines({ 'name' => id, 'datacenter' => datacenter_name }).first
          end
          vm ? vm : raise(Fog::Compute::Vsphere::NotFound, "#{id} was not found")
        end
      end
    end
  end
end
