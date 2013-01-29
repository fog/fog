Shindo.tests("Fog::Compute[:digitalocean] | server model", ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  server  = service.servers.create :name      => 'fog-test',
                                   :image_id  => service.images.first.id,
                                   :region_id => service.regions.first.id,
                                   :flavor_id => service.flavors.first.id

  tests('The server model should') do
    # Wait for the server to come up
    begin
      server.wait_for(120) { server.reload rescue nil; server.ready? }
    rescue Fog::Errors::TimeoutError
      # Server bootstrap took more than 120 secs!
    end

    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ 
        shutdown 
        reboot
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
  end

  server.destroy

end

