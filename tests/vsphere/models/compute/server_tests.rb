Shindo.tests('Fog::Compute[:vsphere] | server model', ['vsphere']) do
  #
  require 'rbvmomi'
  require 'fog'

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

  vm_mob_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::RE_TEMPLATE)
  attrs =  compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
  server = servers.get(attrs['id'])

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
