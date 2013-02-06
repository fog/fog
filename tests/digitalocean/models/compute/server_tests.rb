Shindo.tests("Fog::Compute[:digitalocean] | server model", ['digitalocean', 'compute']) do

  server  = fog_test_server

  tests('The server model should') do

    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ 
        shutdown 
        reboot
        power_cycle
      }.each do |action|
        test(action) { server.respond_to? action }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ 
        :id,
        :name,
        :status,
        :backups_active,
        :flavor_id,
        :region_id,
        :image_id
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
    end
    test('reboot the server') do
      server.reboot
      server.wait_for { server.status == 'off' }
      server.status == 'off'
    end
    test('power_cycle the server') do
      server.wait_for { server.ready? }
      server.power_cycle
      server.wait_for { server.status == 'off' }
      server.status == 'off'
    end

  end

end

