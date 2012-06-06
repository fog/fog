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

      class Real
        include Shared

        def get_vm_properties(vm_moid, options = {})
          raise ArgumentError, "Must pass a vm_moid" unless vm_moid

          if vm_mob_ref = get_vm_mob_ref_by_moid(vm_moid)
            vm = convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
          else
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine with Managed Object Reference #{vm_moid} could not be found."
          end
          vm
        end

        def get_disks_by_vm_mob(vm_mob_ref, options ={})
          devices = vm_mob_ref.config.hardware.device
          disks = devices.select { |vm_device| vm_device.class == RbVmomi::VIM::VirtualDisk }
          results = []
          disks.each do |virtual_disk|
            results << {
                'path'=> virtual_disk.backing.fileName,
                'size' => (virtual_disk.capacityInKB)/1024,
                'scsi_num' =>virtual_disk.unitNumber
            }
          end
          results
        end

        def get_dc_mob_ref_by_path(path, options = {} )
          raise ArgumentError, "Must pass a path" unless path
          dc_mob_ref = @connection.serviceInstance.find_datacenter(path)
          dc_mob_ref
        end

        def get_cs_mob_ref_by_path(path, options = {})
          raise ArgumentError, "Must pass a path" unless path
          path_elements = path.split('/').tap { |ary| ary.shift 2 }
          # The DC name itself.
          template_dc = path_elements.shift
          # If the first path element contains "host" this denotes the hostFolder
          # and needs to be shifted out
          path_elements.shift if path_elements[0] == 'host'
          # The template name.  The remaining elements are the folders in the
          # datacenter.
          cluster_name = path_elements.pop
          dc = get_dc_mob_ref_by_path(template_dc)
          cs_mob_ref = dc.find_compute_resource(cluster_name)
          cs_mob_ref
        end

        def get_clusters_by_dc_mob(dc_mob_ref, options={})
          raise ArgumentError, "Must pass a datacenter management object" unless dc_mob_ref
          cr_mob_refs = dc_mob_ref.hostFolder.childEntity
          results = []
          cr_mob_refs.each do |c|
            results << c if c.kind_of? RbVmomi::VIM::ComputeResource
          end
          results
        end

        def get_hosts_by_cs_mob(cs_mob_ref, options ={})
          host_mob_refs = cs_mob_ref.host
          host_mob_refs
        end

        def get_rps_by_cs_mob(cs_mob_ref, options ={})
          raise ArgumentError, "Must pass a cluster management object" unless cs_mob_ref

          property_specs = [ :type => 'ResourcePool', :all => false, :pathSet =>  ['name']]

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

          obj_spec = RbVmomi::VIM.ObjectSpec(
              :obj => cs_mob_ref,
              :skip => false,
              :selectSet => [
                  compute_resource_rp_traversal_spec,
                  resource_pool_traversal_spec,
                  resource_pool_vm_traversal_spec
              ]
          )

          filter_spec =  RbVmomi::VIM.PropertyFilterSpec(:propSet => property_specs, :objectSet => [obj_spec])
          result = @connection.propertyCollector.RetrieveProperties(:specSet => [filter_spec])
          results = []
          result.each { |r| results << r.obj }
          results
          results
        end

        def get_datastores_by_cs_mob(cs_mob_ref, options ={})
          datastore_mob_refs = cs_mob_ref.datastore
          datastore_mob_refs
        end

        def get_datastores_by_host_mob(host_mob_ref, options ={})
          datastore_mob_refs = host_mob_ref.datastore
          datastore_mob_refs
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
