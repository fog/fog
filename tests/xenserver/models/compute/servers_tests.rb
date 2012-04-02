Shindo.tests('Fog::Compute[:xenserver] | servers collection', ['xenserver']) do

  #require 'pp'
  conn = Fog::Compute[:xenserver]
  # pre-flight cleanup
  (conn.servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end
  # Create some test data
  server = conn.servers.create(:name => test_ephemeral_vm_name, 
                               :template_name => test_template_name)
  server.wait_for { running? }

  tests('The servers collection') do
    servers = conn.servers.all

    test('should not be empty') { !servers.empty? }

    test('should be a kind of Fog::Compute::XenServer::Servers') { servers.kind_of? Fog::Compute::XenServer::Servers }

    tests('should be able to reload itself').succeeds { servers.reload }

    tests('should be able to get a model') do
      tests('by name').succeeds { servers.get_by_name test_ephemeral_vm_name }
      tests('by instance uuid').succeeds { servers.get(servers.get_by_name(test_ephemeral_vm_name).reference) }
    end

  end

end
