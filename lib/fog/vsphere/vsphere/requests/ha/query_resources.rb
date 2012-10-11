module Fog
  module Highavailability
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

        def get_luns_by_host()
          #host_mo_ref = get_mob_ref_by_name('HostSystem', 'w1-vhadp-05.eng.vmware.com')
          host_mo_ref = get_mob_ref_by_name('HostSystem', 'sin2-pekaurora-bdcqe001.eng.vmware.com')

          device_pair = {}
          path_pair = {}
          target_pair = {}
          lun_pair = {}

          plug_devices = host_mo_ref.config.storageDevice.plugStoreTopology.device
          plug_devices.each do |device|
            puts "corresponding lun #{device.lun} path is #{device.path[0]} "
            device_pair[device.lun] = device.path[0]
          end

          plug_pathes = host_mo_ref.config.storageDevice.plugStoreTopology.path
          plug_pathes.each do |path|
            puts "corresponding path #{path.key} target is #{path.target} "
            path_pair[path.key] = path.target
          end

          plug_targets = host_mo_ref.config.storageDevice.plugStoreTopology.target
          plug_targets.each do |target|
            puts "corresponding target #{target.key} transport is #{target.transport} "
            target_pair[target.key] = target.transport
          end

          scsi_luns = host_mo_ref.config.storageDevice.scsiLun
          scsi_luns.each do |lun|
            Fog::Logger.debug("[#{Time.now.rfc2822}] lun key is #{lun.key}[/]")
            path_key = device_pair[lun.key]
            puts path_key
            path_target = path_pair[path_key] unless path_key.nil?
            puts path_target
            target_transport = target_pair[path_target] unless path_target.nil?
            puts target_transport
            lun_pair[lun.canonicalName.to_s] = target_transport
          end
          lun_pair
        end

        def get_luns_by_ds()
          #ds_mo_ref = get_mob_ref_by_name('Datastore','ds04')
          #ds_mo_ref = get_mob_ref_by_name('Datastore','ci-cistage-0')  # share
          ds_mo_ref = get_mob_ref_by_name('Datastore','bdcqe001-7') # local
          lun_pair= get_luns_by_host()
          puts "info type is #{ds_mo_ref.info.vmfs.class.to_s}"
          ds_mo_ref.info.vmfs.extent.each do |e|
             puts "extent name is #{e.diskName}"
             transport = lun_pair[e.diskName]
             puts "corresponding target transport is #{ transport = lun_pair[e.diskName].class.to_s}"
          end
        end

        def get_luns()
          #host_mo_ref = get_mob_ref_by_name('HostSystem', 'w1-vhadp-05.eng.vmware.com') # 'ds01'
          host_mo_ref = get_mob_ref_by_name('HostSystem', 'sin2-pekaurora-bdcqe001.eng.vmware.com')

          device_pair = {}
          path_pair = {}
          target_pair = {}
          lun_pair = {}

          #scsi_luns = host_mo_ref.config.storageDevice.scsiLun
          #puts "plug_devices lun key is #{scsi_luns[0][:key]}"
          #puts "plug_devices lun name is #{scsi_luns[0][:canonicalName]}"

          #plugs = host_mo_ref.config.storageDevice.plugStoreTopology

          #puts "plug_devices lun key is #{plug_devices[0][:lun][:key]}"
          #puts "plug_devices key is #{plug_devices[0][:key].inspect}"
          #puts "plug_devices path is #{plug_devices[0][:path].inspect}"

          #plug_paths = host_mo_ref.config.storageDevice.plugStoreTopology.path
          #puts "plug_paths device is #{plug_paths[0][:device].inspect}"
          #puts "plug_paths key is #{plug_paths[0][:key].inspect}"
          #puts "plug_paths target is #{plug_paths[0][:target].inspect}"

          plug_targets = host_mo_ref.config.storageDevice.plugStoreTopology.target
          plug_targets.each do |target|
            puts "plug_targets key is #{target[:key].inspect}"
            puts "plug_targets transport is #{target[:transport].class.to_s}"
          end

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

      end

      class Mock
        include Shared

      end
    end
  end
end
