
Shindo.tests('Fog::Compute[:xenserver] | server model', ['xenserver']) do

  connection = Fog::Compute[:xenserver]
  servers = connection.servers
  # pre-flight cleanup
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end
  (servers.templates.find_all { |t| t.name == test_ephemeral_vm_name}).each do |s|
    s.destroy
  end

  server = Fog::Compute[:xenserver].servers.create(:name => test_ephemeral_vm_name,
                                                   :template_name => test_template_name)
  server.reload

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ affinity set_attribute refresh stop clean_shutdown hard_shutdown start destroy reboot hard_reboot clean_reboot }.each do |action|
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
        :__affinity,
        :allowed_operations,
        :__consoles,
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
        :__vifs,
        :vcpus_params,
        :vcpus_at_startup,
        :vcpus_max,
        :hvm_boot_policy,
        :hvm_boot_params,
        :pci_bus,
        :pv_kernel,
        :pv_ramdisk,
        :pv_legacy_args,
        :pv_bootloader_args,
        :snapshots
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
    #test('return a Fog::Compute::XenServer::Host affinity') { server.affinity.kind_of? Fog::Compute::XenServer::Host }

  end

  tests("Creating a server") do
    tests("it should create a server") do
      s = nil
      test("named #{test_ephemeral_vm_name}") do
        s = servers.create(:name => test_ephemeral_vm_name,
                           :template_name => test_template_name)
        servers.get(s.reference).name == test_ephemeral_vm_name
      end
      test("and destroy it afterwards") { s.destroy }
    end
    tests("it should create a server") do
      s = nil
      # The template has 2 VIFs already, we add 2 more
      test("with 4 NICs") do
        s = servers.create(:name => test_ephemeral_vm_name,
                           :template_name => test_template_name,
                           :networks => [connection.default_network, connection.default_network])
        s.reload
        s.networks.size == 4
      end
      test("and destroy it afterwards") { s.destroy }
    end
  end

  tests("A real server should") do
    tests("return valid vbds") do
      test("as an array") { server.vbds.kind_of? Array }
      server.vbds.each { |i|
        test("and each VBD should be a Fog::Compute::XenServer::VBD") { i.kind_of? Fog::Compute::XenServer::VBD }
      }
    end

    tests('return valid consoles') do
      test('as an array') { server.consoles.kind_of? Array }
      server.consoles.each { |i|
        test('and each Console should be a Fog::Compute::XenServer::Console') { i.kind_of? Fog::Compute::XenServer::Console }
      }
    end

    test("have 0 or more networks") { server.networks.kind_of? Array }

    tests("have networks if networks > 0") do
      if server.networks.size > 0
        server.networks.each do |n|
          test("and network is of type Fog::Compute::XenServer::Network") do
            n.kind_of? Fog::Compute::XenServer::Network
          end
        end
      end
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

    test("set attribute PV_bootloader to supergrub") do
      server.set_attribute 'PV_bootloader', 'supergrub'
      server.reload
      server.pv_bootloader == 'supergrub'
    end

    tests("Creating a snapshot") do
      snap_ref = server.snapshot('newsnapshot')
      tests("it should create a snapshot") do
        snap_ref = server.snapshot('newsnapshot')
        servers.get(snap_ref).reference == snap_ref
      end
      test("and destroy it afterwards") { servers.get(snap_ref).destroy }
    end

    test("be able to be destroyed!") do
      server.destroy
      servers.get_by_name('fog-test-server-shindo') == nil
    end

  end

end
