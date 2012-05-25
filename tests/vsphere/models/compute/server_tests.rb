Shindo.tests('Fog::Compute[:vsphere] | server model', ['vsphere']) do
  require 'rubygems'
  require 'rbvmomi'
  require 'Fog'


  class ConstClass
    DC_NAME = 'Datacenter2012'# name of test datacenter
    RE_VM_NAME = 'node_server_test'# name of a local vm/template to clone from but with two connected datastore
    RE_TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{RE_VM_NAME}" #path of a remote vm template to test
  end

  servers = Fog::Compute[:vsphere].servers
  compute = Fog::Compute[:vsphere]
  vm_mob_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::RE_TEMPLATE)
  attrs =  compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
  server = servers.get(attrs['id'])
  puts server.mo_ref

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ reboot stop start }.each do |action|
        test(action) { server.respond_to? action }
        test("#{action} returns successfully") { server.send(action.to_sym) ? true : false }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ :id,
                     :instance_uuid,
                     :uuid,
                     :power_state,
                     :tools_state,
                     :mo_ref,
                     :tools_version,
                     :hostname,
                     :mac_addresses,
                     :operatingsystem,
                     :connection_state,
                     :hypervisor,
                     :name,
                     :ipaddress,
                     :is_a_template]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Vsphere::Server') { server.kind_of? Fog::Compute::Vsphere::Server }
  end

end
