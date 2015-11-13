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
      test('guest_processes') { server.respond_to? 'guest_processes' }
      test('take_snapshot') do
        test('responds') { server.respond_to? 'take_snapshot'}
        test('returns successfully') { server.take_snapshot('name' => 'foobar').kind_of? Hash }
      end
      test('snapshots') do
        test('responds') { server.respond_to? 'snapshots'}
        test('returns successfully') { server.snapshots.kind_of? Fog::Compute::Vsphere::Snapshots }
      end
      test('find_snapshot') do
        test('responds') { server.respond_to? 'find_snapshot'}
        test('returns successfully') do
          server.find_snapshot('snapshot-0101').kind_of? Fog::Compute::Vsphere::Snapshot
        end
        test('returns correct snapshot') do
          server.find_snapshot('snapshot-0101').ref == 'snapshot-0101'
        end
      end
      tests('revert_snapshot') do
        test('responds') { server.respond_to? 'revert_snapshot'}
        tests('returns correctly') do
          test('when correct input given') { server.revert_snapshot('snapshot-0101').kind_of? Hash }
          test('when incorrect input given') do
            raises(ArgumentError) { server.revert_snapshot(1) }
          end
        end
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
        :public_ip_address]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Vsphere::Server') { server.kind_of? Fog::Compute::Vsphere::Server }
  end

end
