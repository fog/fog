# totally new
Shindo.tests("Fog::Storage[:vsphere] | volume", ['vsphere']) do
  require 'rbvmomi'
  require 'fog'
  require '../../../helpers/model_helper'
  require '../../../helpers/succeeds_helper'

  class ConstClass
    TEMPLATE = "/Datacenters/Datacenter2012/vm/node_server_test" #path of a vm which need create disks
    MOB_TYPE = 'VirtualMachine' # type refereed to an effective VirtualMachine management object
    DS_NAME =  'ds02'# name referring to a datastore which include vmdks need to re-config
    VM_NAME = 'node_server_test'
    VMDK_PATH1 = "[#{DS_NAME}] node_server_test/node_server_test_x.vmdk" #path of a vmdk to re-config which belong to above mentioned datastore
    DE_NAME  = 'Hard disk 2'
    DISK_SIZE = 200
  end

  #storage = Fog::Storage.new({:provider => 'vsphere', 'clusters' => %w{cluster-fog}})
  #vm_mob_ref = storage.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)

  model_tests(Fog::Storage[:vsphere].volumes, {:vm_mo_ref => 'vm-4429', :fullpath => ConstClass::VMDK_PATH1, :size => ConstClass::DISK_SIZE, :device_name => ConstClass::DE_NAME}, true)

end
