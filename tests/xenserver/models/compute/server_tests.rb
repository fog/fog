
Shindo.tests('Fog::Compute[:xenserver] | server model', ['xenserver']) do

  servers = Fog::Compute[:xenserver].servers
  # pre-flight cleanup
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end
  
  server = Fog::Compute[:xenserver].servers.create(:name => test_ephemeral_vm_name, 
                                                   :template_name => test_template_name)
  server.reload

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ refresh stop clean_shutdown hard_shutdown start destroy reboot hard_reboot clean_reboot }.each do |action|
        test(action) { server.respond_to? action }
        #test("#{action} returns successfully") { server.send(action.to_sym) ? true : false }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ 
        :reference,
        :uuid,
        :is_a_template,
        :affinity,
        :allowed_operations,
        :consoles,
        :domarch,
        :domid,
        :__guest_metrics,
        :is_a_snapshot,
        :is_a_template,
        :is_control_domain,
        :memory_dynamic_max,
        :memory_dynamic_min,
        :memory_static_max,
        :memory_static_min,
        :memory_target,
        :metrics,
        :name_description,
        :other_config,
        :power_state,
        :pv_args,            
        :__resident_on,
        :__vbds,            
        :vcpus_at_startup,   
        :vcpus_max,         
        :__vifs
      ]
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

    test('be a kind of Fog::Compute::XenServer::Server') { server.kind_of? Fog::Compute::XenServer::Server }

  end

  tests("A real server should") do
    tests("return valid vbds") do
      test("as an array") { server.vbds.kind_of? Array }
      server.vbds.each { |i| 
          test("and each VBD should be a Fog::Compute::XenServer::VBD") { i.kind_of? Fog::Compute::XenServer::VBD }
      } 
    end
    test("reside on a Fog::Compute::XenServer::Host") { server.resident_on.kind_of? Fog::Compute::XenServer::Host }
    #test("have Fog::Compute::XenServer::GuestMetrics") { server.guest_metrics.kind_of? Fog::Compute::XenServer::GuestMetrics }
    test("be able to refresh itself") { server.refresh }

    test("always stop when I say stop('hard')") do
      server.stop 'hard'
    end
    
    # shutdown is async apparently, we wait
    test("not be running when it's stopped") do
      server.wait_for { !server.running? }
      true
    end
    
    test("do nothing when I say stop('hard') but it's not running") do
      server.stop('hard') == false
    end
    
    test("always start when I say start") do
      server.start
    end
    
    # start is async apparently, we wait
    test("be running if I started the server") do
      server.wait_for { server.running? }
      true
    end
    
    test("be able to be destroyed!") do
      server.destroy
      servers.get_by_name('fog-test-server-shindo') == nil
    end

  end

end
