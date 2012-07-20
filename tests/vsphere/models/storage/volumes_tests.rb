Shindo.tests("Fog::Storage[:vsphere] | volumes", ['vsphere']) do


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

  storage = Fog::Storage.new({:provider => 'vsphere', 'clusters' => %w{cluster-fog}})
  vm_mob_ref = storage.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)
  attrs = {}
  #attrs =  storage.convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
  attrs['mo_ref'] = 'vm-4429'
  params = {:vm_mo_ref => attrs['mo_ref'], :fullpath => ConstClass::VMDK_PATH1, :size => ConstClass::DISK_SIZE, :device_name => ConstClass::DE_NAME}
  collection = Fog::Storage[:vsphere].volumes

  tests('success') do

    tests("#new(#{params.inspect})").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      collection.new(params)
    end

    tests("#create(#{params.inspect})").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @instance = collection.create(params)
    end

    tests("#all").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      collection.all(attrs['mo_ref'])
    end

    tests("#get(#{params.inspect})").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      volume = collection.get(attrs['mo_ref'], ConstClass::DE_NAME)
      tests('The volume model should') do
        tests('have the action') do
          %w{ save destroy }.each do |action|
            test(action) { volume.respond_to? action }
          end
        end
        tests('have attributes') do
          attributes = [ :vm_mo_ref,
                         :device_name,
                         :fullpath,
                         :size,
                         :scsi_key,
                         :unit_number,
                         :datastore_name]
          tests("The volume model should respond to") do
            attributes.each do |attribute|
              test("#{attribute}") { volume.respond_to? attribute }
            end
          end
        end
        test('be a kind of Fog::Storage::Vsphere::Volume') { volume.kind_of? Fog::Storage::Vsphere::Volume }
      end

    end

    tests("#destroy(#{params.inspect})").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @instance.destroy
    end
  end



end