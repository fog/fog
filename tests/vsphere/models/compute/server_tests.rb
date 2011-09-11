Shindo.tests('Fog::Compute[:vsphere] | server model', ['vsphere']) do

  servers = Fog::Compute[:vsphere].servers
  server = servers.last

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ stop start destroy reboot }.each do |action|
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
