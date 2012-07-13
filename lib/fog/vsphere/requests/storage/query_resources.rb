module Fog
  module Storage
    class Vsphere

      module Shared

        def get_filterSpec_by_type(type)
          raise ArgumentError, "Must pass a type" unless type

          property_specs = [ :type => type, :all => false, :pathSet =>  ['name']]

          resource_pool_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "resourcePoolTraversalSpec",
              :type => 'ResourcePool',
              :path => 'resourcePool',
              :skip => false,
              :selectSet => [
                  RbVmomi::VIM.SelectionSpec(:name => "resourcePoolTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "resourcePoolVmTraversalSpec")
              ]
          )

          resource_pool_vm_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "resourcePoolVmTraversalSpec",
              :type => 'ResourcePool',
              :path => 'vm',
              :skip => false
          )

          compute_resource_rp_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "computeResourceRpTraversalSpec",
              :type => 'ComputeResource',
              :path => 'resourcePool',
              :skip => false,
              :selectSet => [
                  RbVmomi::VIM.SelectionSpec(:name => "resourcePoolTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "resourcePoolVmTraversalSpec")
              ]
          )

          compute_resource_datastore_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "computeResourceDatastoreTraversalSpec",
              :type => 'ComputeResource',
              :path => 'datastore',
              :skip => false
          )

          compute_resource_host_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "computeResourceHostTraversalSpec",
              :type => 'ComputeResource',
              :path => 'host',
              :skip => false
          )

          datacenter_host_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "datacenterHostTraversalSpec",
              :type => 'Datacenter',
              :path => 'hostFolder',
              :skip => false,
              :selectSet => [
                  RbVmomi::VIM.SelectionSpec(:name => "folderTraversalSpec")
              ]
          )

          datacenter_vm_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "datacenterVmTraversalSpec",
              :type => 'Datacenter',
              :path => 'vmFolder',
              :skip => false,
              :selectSet => [
                  RbVmomi::VIM.SelectionSpec(:name => "folderTraversalSpec")
              ]
          )

          host_vm_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "hostVmTraversalSpec",
              :type => 'HostSystem',
              :path => 'vm',
              :skip => false,
              :selectSet => [
                  RbVmomi::VIM.SelectionSpec(:name => "folderTraversalSpec")
              ]
          )

          folder_traversal_spec = RbVmomi::VIM.TraversalSpec(
              :name => "folderTraversalSpec",
              :type => 'Folder',
              :path => 'childEntity',
              :skip => false,
              :selectSet => [
                  RbVmomi::VIM.SelectionSpec(:name => "folderTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "datacenterHostTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "datacenterVmTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "computeResourceRpTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "computeResourceDatastoreTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "computeResourceHostTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "hostVmTraversalSpec"),
                  RbVmomi::VIM.SelectionSpec(:name => "resourcePoolVmTraversalSpec")
              ]
          )

          obj_spec = RbVmomi::VIM.ObjectSpec(
              :obj => @connection.rootFolder,
              :skip => false,
              :selectSet => [
                  folder_traversal_spec,
                  datacenter_vm_traversal_spec,
                  datacenter_host_traversal_spec,
                  compute_resource_host_traversal_spec,
                  compute_resource_datastore_traversal_spec,
                  compute_resource_rp_traversal_spec,
                  resource_pool_traversal_spec,
                  host_vm_traversal_spec,
                  resource_pool_vm_traversal_spec
              ]
          )

          filter_spec =  RbVmomi::VIM.PropertyFilterSpec(:propSet => property_specs, :objectSet => [obj_spec])
          filter_spec
        end

      end

      class Real
        include Shared

        def get_dc_mob_ref_by_path(path, options = {} )
          raise ArgumentError, "Must pass a path" unless path
          dc_mob_ref = @connection.serviceInstance.find_datacenter(path)
          dc_mob_ref
        end

        def get_vm_mob_ref_by_moid(vm_moid)
          raise ArgumentError, "Must pass a vm management object id" unless vm_moid
          vm_mob_ref = RbVmomi::VIM::VirtualMachine.new(@connection,vm_moid)
          vm_mob_ref
        end

        def get_parent_dc_by_vm_mob(vm_mob_ref, options = {})
          mob_ref = vm_mob_ref.parent || vm_mob_ref.parentVApp
          while !(mob_ref.kind_of? RbVmomi::VIM::Datacenter)
            mob_ref = mob_ref.parent
          end
          mob_ref
        end

        def get_ds_name_by_path(vmdk_path)
          path_elements = vmdk_path.split('[').tap { |ary| ary.shift }
          template_ds = path_elements.shift
          template_ds = template_ds.split(']')
          datastore_name = template_ds[0]
          datastore_name
        end

        def get_folder_path(folder, root = nil)
          if ( not folder.methods.include?('parent') ) or ( folder == root )
            return
          end
          "#{get_folder_path(folder.parent)}/#{folder.name}"
        end

        def get_vm_mob_ref_by_path (options = {})
          raise ArgumentError, "Must pass a path option" unless options['path']
          path_elements = options['path'].split('/').tap { |ary| ary.shift 2 }
          # The DC name itself.
          template_dc = path_elements.shift
          # If the first path element contains "vm" this denotes the vmFolder
          # and needs to be shifted out
          path_elements.shift if path_elements[0] == 'vm'
          # The template name.  The remaining elements are the folders in the
          # datacenter.
          template_name = path_elements.pop
          dc_mob_ref = get_dc_mob_ref_by_path(template_dc)
          vm_mob_ref = dc_mob_ref.find_vm(template_name)
          vm_mob_ref
        end

        def get_mob_ref_by_moid(type, moid)
          raise ArgumentError, "Must pass a type" unless type
          raise ArgumentError, "Must pass a moid" unless moid
          filter_spec = get_filterSpec_by_type(type)
          result = @connection.propertyCollector.RetrieveProperties(:specSet => [filter_spec])
          results = Hash[result.map do |x|
            [x.obj._ref, x.obj]
          end]
          mob_ref = results.fetch(moid)
          mob_ref
        end

        def get_mob_ref_by_name(type, name)
          raise ArgumentError, "Must pass a type" unless type
          raise ArgumentError, "Must pass a name" unless name
          filter_spec = get_filterSpec_by_type(type)
          result = @connection.propertyCollector.RetrieveProperties(:specSet => [filter_spec])
          results = Hash[result.map do |x|
            [x.obj.name, x.obj]
          end]
          mob_ref = results.fetch(name)
          mob_ref
        end

        def get_cs_mob_ref_by_moid(cs_moid)
          raise ArgumentError, "Must pass a vm management object id" unless cs_moid
          cs_mob_ref = RbVmomi::VIM::ComputeResource.new(@connection,cs_moid)
          cs_mob_ref
        end

        def fetch_host_storage_resource(options = {})
          @host_list = {}
          @clusters.each do |cs_mob_ref|
            host_mob_refs = cs_mob_ref.host
            host_mob_refs.each do |host_mob_ref|
              next if (!(options['hosts'].nil?)&&!(options['hosts'].include?(host_mob_ref.name)))
              host_resource = HostResource.new
              host_resource.cluster = cs_mob_ref
              host_resource.mob = host_mob_ref
              host_resource.name = host_mob_ref.name
              Fog::Logger.deprecation ( "host_resource.name = #{host_resource.name}")
              host_resource.connection_state = host_mob_ref.summary.runtime.connectionState
              host_datastores = host_mob_ref.datastore
              Fog::Logger.deprecation ( "host_datastores size = #{host_datastores.size}")
              # host_resource.share_datastores = fetch_datastores(host_datastores,
              #options['share_datastore_pattern'], true)
              #Fog::Logger.deprecation("warning: no matched sharestores in host:#{host_resource.name}") if host_resource.share_datastores.empty?
              host_resource.local_datastores = fetch_datastores(host_datastores,
                                                                options['local_datastore_pattern'], false)
              host_resource.place_local_datastores = fetch_datastores(host_datastores,
                                                                options['local_datastore_pattern'], false)
              Fog::Logger.deprecation("warning: no matched localstores in host:#{host_resource.name}") if host_resource.local_datastores.empty?
              #Fog::Logger.deprecation( "total ds number for one host = #{@datastore_list.size}") unless @datastore_list.nil?
              @host_list[host_resource.name]  = host_resource
            end
          end
          Fog::Logger.deprecation( "total host number = #{@host_list.size}")
          @host_list
        end

        def fetch_datastores(datastore_mobs, match_patterns, type)
          datastores = {}
          #return datastore_mobs if match_patterns.nil?
          datastore_mobs.each do |datastore_mob|
            if !(match_patterns.nil?)
              next unless isMatched?(datastore_mob.name, match_patterns)
            end
            datastore_resource                   = DatastoreResource.new
            datastore_resource.shared            = type
            datastore_resource.mob               = datastore_mob
            datastore_resource.name              = datastore_mob.name
            datastore_resource.free_space        = datastore_mob.summary.freeSpace.to_i/(1024*1024)
            datastore_resource.total_space       = datastore_mob.summary.capacity.to_i/(1024*1024)
            datastore_resource.unaccounted_space = 0
            datastores[datastore_resource.name]  = datastore_resource
            #@datastore_list[datastore_resource.name]  = datastore_resource
          end
          Fog::Logger.deprecation("datastores length = #{datastores.size}")
          datastores
        end

        def get_disks_by_vm_mob(vm_moid)
          vm_mob_ref = get_vm_mob_ref_by_moid(vm_moid)
          devices = vm_mob_ref.config.hardware.device
          disks = devices.select { |vm_device| vm_device.class == RbVmomi::VIM::VirtualDisk }
          results = []
          disks.each do |virtual_disk|
            path = virtual_disk.backing.fileName
            ds_name = get_ds_name_by_path(path)
            results << {
                'vm_mo_ref' => vm_mob_ref._ref,
                'device_name' => virtual_disk.deviceInfo.label,
                'fullpath'=> path,
                'size' => (virtual_disk.capacityInKB)/1024,
                'scsi_key' =>virtual_disk.key,
                'scsi_num' =>virtual_disk.unitNumber ,
                'datastore_name' => ds_name
            }
          end
          { 'volume_info' => results }
        end

        def get_vm_properties(vm_moid, options = {})
          raise ArgumentError, "Must pass a vm_moid" unless vm_moid

          if vm_mob_ref = get_vm_mob_ref_by_moid(vm_moid)
            vm = convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
          else
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine with Managed Object Reference #{vm_moid} could not be found."
          end
          vm
        end

        def get_disks_by_vm_mob_and_device_name(vm_moid, device_name)
          vm_mob_ref = get_vm_mob_ref_by_moid(vm_moid)
          devices = vm_mob_ref.config.hardware.device
          disks = devices.select { |vm_device| vm_device.class == RbVmomi::VIM::VirtualDisk }
          results = []
          disks.each do |virtual_disk|
            if virtual_disk.deviceInfo.label != device_name
              next
            end
            path = virtual_disk.backing.fileName
            ds_name = get_ds_name_by_path(path)
            results << {
                'vm_mo_ref' => vm_mob_ref._ref,
                'device_name' => device_name,
                'fullpath'=> path,
                'size' => (virtual_disk.capacityInKB)/1024,
                'scsi_key'=> virtual_disk.key,
                'unit_number' =>virtual_disk.unitNumber ,
                'datastore_name' => ds_name
            }
          end
          { 'volume_info' => results }
        end

        def get_vms_by_host_mob(host_mob_ref, options ={})
          vm_mob_refs = host_mob_ref.vm
          vm_mob_refs
        end

      end

      class Mock
        include Shared
        def query_vm_status(options = {})
          {"ipadress"=>nil, "power_state"=>"poweredOn"}
        end

        def get_disks_by_vm_mob(vm_mob_ref, options ={})
          [{"path"=>"[DS91733] knife/knife_1.vmdk", "size"=>20971520, "scsi_num"=>0}]
        end

      end
    end
  end
end
