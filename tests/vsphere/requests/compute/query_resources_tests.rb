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

Shindo.tests("Fog::Compute[:vsphere] | query resources request", ['vsphere']) do

  require 'rbvmomi'
  require 'fog'
  compute = Fog::Compute[:vsphere]

  # need set down below consts according to real VSphere data center
  class ConstClass
    DC_NAME = 'datacenter'# name of test datacenter
    CS_NAME = 'cluster01' # name referring to a cluster sits in above datacenter
    CLUSTER_PATH = "/Datacenters/#{DC_NAME}/host/#{CS_NAME}" #path of above cluster
    HOST_NAME = 'w1-vhadp-05.eng.vmware.com' # name referring to a host sits in above cluster
    VM_NAME = 'node_network_test' # name referring to a vm sits in above host
  end

  tests("When getting management object for a specific data center") do
    dc_mob_ref = compute.get_dc_mob_ref_by_path(ConstClass::DC_NAME)
    test("it should return a mob ref to datacenter") do
      dc_mob_ref.kind_of? RbVmomi::VIM::Datacenter
    end
    tests("The mob ref has a right name") {dc_mob_ref.name == ConstClass::DC_NAME }
    tests("When getting clusters belong to a specific datacenter") do
      response = compute.get_clusters_by_dc_mob(dc_mob_ref)
      test("it should return a Array") { response.kind_of? Array }

      tests("The response should") do
        test("contain at least one cluster") { response.length >= 1 }
        test("contain that is a mob refer to cluster") do
          response[0].kind_of? RbVmomi::VIM::ComputeResource
        end
      end
    end
  end


  tests("When getting a cluster by a path") do
    cs_mob_ref = compute.get_cs_mob_ref_by_path(ConstClass::CLUSTER_PATH)

    test("it should return a mob refer to Cluster") do
      cs_mob_ref.kind_of? RbVmomi::VIM::ComputeResource
    end
    tests("The mob ref has a right name") {cs_mob_ref.name == ConstClass::CS_NAME }

    tests("When getting hosts belong to a specific cluster") do
      response = compute.get_hosts_by_cs_mob(cs_mob_ref)
      test("it should return a Array") { response.kind_of? Array }
      tests("The response should") do
        test("contain at least one cluster") { response.length >= 1 }
        test("contain that is a mob refer to HostSystem") do
          response[0].kind_of? RbVmomi::VIM::HostSystem
        end
      end

      host_mob_ref = response.find {|h| h.name == ConstClass::HOST_NAME }
      tests("When getting datastores belong to a specific Host") do
        response = compute.get_datastores_by_host_mob(host_mob_ref)
        test("it should return a Array") { response.kind_of? Array }
        tests("The response should") do
          test("contain at least one cluster") { response.length >= 1 }
          test("contain that is a mob refer to Datastore") do
            response[0].kind_of? RbVmomi::VIM::Datastore
          end
        end
      end
      tests("When getting vms belong to a specific Host") do
        response = compute.get_vms_by_host_mob(host_mob_ref)
        test("it should return a Array") { response.kind_of? Array }
        tests("The response should") do
          test("contain at least one cluster") { response.length >= 1 }
          test("contain that is a mob refer to VirtualMachine") do
            response[0].kind_of? RbVmomi::VIM::VirtualMachine
          end
        end

        vm_mob_ref = host_mob_ref.vm.find {|v| v.name == ConstClass::VM_NAME }
        tests("When getting properties for a specific vm") do
          test("it should return a Hash") do
            compute.get_vm_properties(vm_mob_ref._ref.to_s).kind_of? Hash
          end
          tests("The properties getting should") do
            response = compute.get_vm_properties(vm_mob_ref._ref.to_s)
            %w{ name ipaddress power_state }.each do |key|
              test("have a #{key} key") { response.has_key? key }
            end
          end
        end
        tests("When getting disks for a specific vm") do
          test("it should return a Array") do
            compute.get_disks_by_vm_mob(vm_mob_ref).kind_of? Array
          end
          tests("The disks getting should") do
            attr_array = compute.get_disks_by_vm_mob(vm_mob_ref)
            %w{ path size scsi_num }.each do |key|
              test("have a #{key} key") { attr_array[0].has_key? key }
            end
          end
        end
      end

    end

    tests("When getting resource pools belong to a specific cluster") do
      response = compute.get_rps_by_cs_mob(cs_mob_ref)
      test("it should return a Array") { response.kind_of? Array }
      tests("The response should") do
        test("contain at least one cluster") { response.length >= 1 }
        test("contain that is a mob refer to ResourcePool") do
          response[0].kind_of? RbVmomi::VIM::ResourcePool
        end
      end
      tests("When getting nested resource pools belong to a specific cluster") do
        response_2 = compute.get_rps_by_cs_mob(cs_mob_ref)
        test("it should return a Array") { response_2.kind_of? Array }
        tests("The response should") do
          test("return more results than flat search") { response_2.length >= response.length }
          test("contain that is a mob refer to ResourePool") do
            response_2[1].kind_of? RbVmomi::VIM::ResourcePool
          end
        end
      end
    end

    tests("When getting datastores belong to a specific cluster") do
      response = compute.get_datastores_by_cs_mob(cs_mob_ref)
      test("it should return a Array") { response.kind_of? Array }
      tests("The response should") do
        test("contain at least one cluster") { response.length >= 1 }
        test("contain that is a mob refer to Datastore") do
          response[0].kind_of? RbVmomi::VIM::Datastore
        end
      end
    end

  end
end

