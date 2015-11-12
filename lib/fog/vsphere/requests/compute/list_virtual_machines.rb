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
            [get_virtual_machine(options['instance_uuid'])]
          elsif options[:folder] && options[:datacenter] then
            list_all_virtual_machines_in_folder(options[:folder], options[:datacenter])
          else
            list_all_virtual_machines(options)
          end
        end


        private

        def list_all_virtual_machines_in_folder(path, datacenter_name)
          folder = get_raw_vmfolder(path, datacenter_name)

          vms = folder.children.grep(RbVmomi::VIM::VirtualMachine)
          # remove all template based virtual machines
          vms.delete_if { |v| v.config.nil? or v.config.template }
          vms.map(&method(:convert_vm_mob_ref_to_attr_hash))
        end

        def list_all_virtual_machines(options = { })
          raw_vms = raw_list_all_virtual_machines(options[:datacenter])
          vms = convert_vm_view_to_attr_hash(raw_vms)

          # remove all template based virtual machines
          vms.delete_if { |v| v['template'] }
          vms
        end

        def raw_list_all_virtual_machines(datacenter_name = nil)
          ## Moved this to its own function since trying to get a list of all virtual machines
          ## to parse for a find function took way too long. The raw list returned will make it
          ## much faster to interact for some functions.
          datacenters = find_datacenters(datacenter_name)
          datacenters.map do |dc|
            @connection.serviceContent.viewManager.CreateContainerView({
                                                                           :container  => dc.vmFolder,
                                                                           :type       =>  ["VirtualMachine"],
                                                                           :recursive  => true
                                                                       }).view
          end.flatten
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
          if options['instance_uuid'].nil? and options['mo_ref'].nil?
            self.data[:servers].values
          elsif !options['instance_uuid'].nil?
            server = self.data[:servers][options['instance_uuid']]
            server.nil? ? [] : [server]
          else
            self.data[:servers].values.select{|vm| vm['mo_ref'] == options['mo_ref']}
          end
        end
      end
    end
  end
end
