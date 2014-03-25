Shindo.tests('Fog::Compute[:xenserver] | servers collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]
  destroy_ephemeral_servers
  servers = conn.servers
  templates = conn.servers.templates
    
  tests('The servers collection') do
    servers = conn.servers.all

    test('should be empty') do
      servers.empty? 
    end

    server = conn.servers.create(:name => test_ephemeral_vm_name, 
                                 :template_name => test_template_name)
    test('should NOT be empty') do
      servers.reload
      !servers.empty? 
    end
    server.destroy

    test('should be a kind of Fog::Compute::XenServer::Servers') { servers.kind_of? Fog::Compute::XenServer::Servers }

    test('should be a kind of Fog::Compute::XenServer::Servers') { servers.kind_of? Fog::Compute::XenServer::Servers }

    tests('should have Fog::Compute::XenServer::Servers inside') do
      conn.servers.each do |s|
        test { s.kind_of? Fog::Compute::XenServer::Server }
      end
    end

    test("should return a list of templates") do
      templates.kind_of? Array
    end

    tests("The servers template list should") do
      test("should include only templates in servers.templates") do
        ok = true
        templates.each { |t| ok = false if !t.is_a_template }
        ok
      end
      test("include a #{test_template_name} template in custom_templates") do
        found = false
        servers.custom_templates.each do |s|
          found = (s.name == test_template_name)
        end
        found
      end 
      test("NOT include a #{test_template_name} template in built-in templates") do
        found = false
        servers.builtin_templates.each do |s|
          found = (s.name != test_template_name)
        end
        found
      end 
      # This may fail in other test scenarios with more than one built-in template
      # present
      test("include only one custom template") { servers.custom_templates.size == 1 }
      tests("not include built-in templates in custom_templates") do
        servers.custom_templates.each do |s|
          test("#{s.name} is NOT a built-in template") {s.allowed_operations.include?('destroy') }
        end
      end
      test("include more than one built-in templates") { servers.builtin_templates.size >= 1 }
      tests("not include real servers") do
        servers.builtin_templates.each do |s|
          test("#{s.name} is not a real server") { s.is_a_template }
        end
      end
    end

    tests('should be able to reload itself').succeeds { servers.reload }

    tests('should be able to get a model') do
      server = conn.servers.create(:name => test_ephemeral_vm_name, 
                                   :template_name => test_template_name)
      test('by name') { servers.get_by_name(test_ephemeral_vm_name).kind_of? Fog::Compute::XenServer::Server }
      test('by instance uuid') { servers.get_by_uuid(server.uuid).kind_of? Fog::Compute::XenServer::Server }
      test('by instance reference') { servers.get(server.reference).kind_of? Fog::Compute::XenServer::Server }
      server.destroy
    end

  end

  # Teardown cleaup
  destroy_ephemeral_servers

end
