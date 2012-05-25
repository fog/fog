Shindo.tests('Fog::Compute[:vsphere] | servers collection', ['vsphere']) do

  require 'rbvmomi'
  require 'fog'
  require '../../../helpers/succeeds_helper'
  servers = Fog::Compute[:vsphere].servers
  compute = Fog::Compute[:vsphere]

  class ConstClass
    DC_NAME = 'Datacenter2012'# name of test datacenter
    RE_VM_NAME = 'node_static_ip'# name of a local vm/template to clone from but with two connected datastore
    RE_TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{RE_VM_NAME}" #path of a remote vm template to test
  end

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
