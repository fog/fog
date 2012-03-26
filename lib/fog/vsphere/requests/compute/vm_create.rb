module Fog
  module Compute
    class Vsphere

      module Shared
        private
        def vm_create_check_options(options)
          options = { 'force' => false }.merge(options)
          required_options = %w{ path name cluster }
          required_options.each do |param|
            raise ArgumentError, "#{required_options.join(', ')} are required" unless options.has_key? param
          end
          # The tap removes the leading empty string
          path_elements = options['path'].split('/').tap { |o| o.shift }
          first_folder = path_elements.shift
          if first_folder != 'Datacenters' then
            raise ArgumentError, "vm_create path option must start with /Datacenters.  Got: #{options['path']}"
          end
          dc_name = path_elements.shift
          if not self.datacenters.include? dc_name then
            raise ArgumentError, "Datacenter #{dc_name} does not exist, only datacenters #{self.datacenters.join(",")} are accessible."
          end
          options
        end
      end

      class Real
        include Shared
        def vm_create(options = {})
          # Option handling
          options = vm_create_check_options(options)
          path_elements = options['path'].split('/').tap { |ary| ary.shift 2 }
          dc_name = path_elements.shift
          vm_cfg = {
            :name                => options['name'],
            :guestId             => options['guest_id'] ? options['guest_id'] : 'otherGuest',
            :files               => { :vmPathName => "[#{options['datastore']}]" },
            :numCPUs             => options['num_cpus'] ? options['num_cpus'] : 1 ,
            :memoryMB            => options['memory'] ? options['memory'] : 512,
            :memoryHotAddEnabled => options['memory_hot_add_enabled'] ? options['memory_hot_add_enabled'] : 0,
            :cpuHotAddEnabled    => options['cpu_hot_add_enabled'] ? options['cpu_hot_add_enabled'] : 0,
            :deviceChange        => options['device_array'].class == Array ? options['device_array'] : nil,
            :extraConfig         => options['extra_config'].class == Array ? options['extra_config'] : nil,
          }
          self.datacenters
          dc = @datacenters[dc_name]
          vm_folder = dc.vmFolder
          folder = path_elements.inject(vm_folder) do |current_folder, sub_folder_name|
            sub_folder = current_folder.find(sub_folder_name, RbVmomi::VIM::Folder)
            raise ArgumentError, "Could not descend into #{sub_folder_name}.  Please check your path." unless sub_folder
            sub_folder
          end
          clusters = dc.hostFolder.children
          build_cluster=''
          clusters.each { |my_cluster|
            if "#{my_cluster.name}" == "#{options['cluster']}"
              build_cluster=my_cluster
            end
          }
          resource_pool = build_cluster.resourcePool
          task=folder.CreateVM_Task(:config => vm_cfg, :pool => resource_pool)
          if options['wait'] then
            new_vm = task.wait_for_completion
          else
            tries = 0
            new_vm = begin
              folder.find(options['name'], RbVmomi::VIM::VirtualMachine) or raise Fog::Vsphere::Errors::NotFound
            rescue Fog::Vsphere::Errors::NotFound
              tries += 1
              if tries <= 10 then
                sleep 15
                retry
              end
                nil
            end
          end
          {
            'vm_ref'        => new_vm ? new_vm._ref : nil,
            'vm_attributes' => new_vm ? convert_vm_mob_ref_to_attr_hash(new_vm) : {},
            'task_ref'      => task._ref
          }
        end
      end
      class Mock
        include Shared
        def vm_create(options = {})
          # Option handling
          options = vm_create_check_options(options)
          {
            'vm_ref'   => 'vm-123',
            'task_ref' => 'task-1234'
          }
        end
      end
    end
  end
end
