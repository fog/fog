Shindo.tests("Fog::Compute[:digitalocean] | server model", ['digitalocean', 'compute']) do

  server  = fog_test_server

  tests('The server model should') do

    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{
        shutdown
        reboot
        power_cycle
        stop
        start
      }.each do |action|
        test(action) { server.respond_to? action }
      end
    end

    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [
        :id,
        :name,
        :state,
        :backups_active,
        :public_ip_address,
        :private_ip_address,
        :flavor_id,
        :region_id,
        :image_id,
        :created_at,
        :ssh_keys=
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
    end

    test('#reboot') do
      pending if Fog.mocking?
      server.reboot
      server.wait_for { server.state == 'off' }
      server.state == 'off'
    end

    test('#power_cycle') do
      pending if Fog.mocking?
      server.wait_for { server.ready? }
      server.power_cycle
      server.wait_for { server.state == 'off' }
      server.state == 'off'
    end

    test('#stop') do
      server.stop
      server.wait_for { server.state == 'off' }
      server.state == 'off'
    end

    test('#start') do
      server.start
      server.wait_for { ready? }
      server.ready?
    end

    # DigitalOcean shutdown is unreliable
    # so disable it in real mode for now
    test('#shutdown') do
      pending unless Fog.mocking?
      server.start
      server.wait_for { server.ready? }
      server.shutdown
      server.wait_for { server.state == 'off' }
      server.state == 'off'
    end

    test('#update') do
      begin
        server.update
      rescue NotImplementedError => e
        true
      end
    end
  end

  # restore server state
  server.start
  server.wait_for { ready? }

end
