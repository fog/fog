module Fog
  module Compute
    class Vsphere
      class Real
        def list_templates(options = { })
          options[:folder] ||= options['folder']
          if options[:folder] then
            list_all_templates_in_folder(options[:folder], options[:datacenter])
          else
            list_all_templates(options)
          end
        end

        private

        def list_all_templates_in_folder(path, datacenter_name)
          folder = get_raw_vmfolder(path, datacenter_name)

          vms = folder.children.grep(RbVmomi::VIM::VirtualMachine)
          # remove all virtual machines that are not template
          vms.delete_if { |v| v.config.nil? or not v.config.template }

          vms.map(&method(:convert_vm_mob_ref_to_attr_hash))
        end

        def list_all_templates(options = {})
          datacenters = find_datacenters(options[:datacenter])

          vms = datacenters.map do |dc|
            @connection.serviceContent.viewManager.CreateContainerView({
              :container  => dc.vmFolder,
              :type       =>  ["VirtualMachine"],
              :recursive  => true
            }).view
          end.flatten
          # remove all virtual machines that are not templates
          vms.delete_if { |v| v.config.nil? or not v.config.template }

          vms.map(&method(:convert_vm_mob_ref_to_attr_hash))
        end
      end
      class Mock
        def list_templates(filters = { })
        end
      end
    end
  end
end
