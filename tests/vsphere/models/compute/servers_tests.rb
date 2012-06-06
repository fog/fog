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

Shindo.tests('Fog::Compute[:vsphere] | servers collection', ['vsphere']) do

  require 'rbvmomi'
  require 'fog'
  require '../../../helpers/succeeds_helper'

  # Internal const-class: contains settings needed to run unit tests
  class ConstClass
    DC_NAME = 'datacenter'# name of test datacenter
    RE_VM_NAME = 'node_clone_test_local'# name of a local vm/template to clone from but with two connected datastore
    RE_TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{RE_VM_NAME}" #path of a complete vm template to test
  end

  # provisioning needed object handle to finish below tests
  servers = Fog::Compute[:vsphere].servers
  # used to get management object id of template set in const-class
  compute = Fog::Compute[:vsphere]

  tests('The servers collection') do
    test('should not be empty') { not servers.empty? }
    test('should be a kind of Fog::Compute::Vsphere::Servers') { servers.kind_of? Fog::Compute::Vsphere::Servers }
    tests('should be able to reload itself').succeeds { servers.reload }
    vm_mob_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::RE_TEMPLATE)
    attrs =  compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
    tests('should be able to get a model') do
      tests('by managed object reference or not').succeeds { servers.get attrs['id'] }
      tests('by instance uuid').succeeds { servers.get attrs['instance_uuid'] }
    end
  end

end
