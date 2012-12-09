Shindo.tests("Fog::Compute[:openstack] | server", ['openstack']) do

  tests('success') do
    tests('#security_groups').succeeds do
      fog = Fog::Compute[:openstack]

      begin
        my_group = fog.security_groups.create(:name => 'my_group',
                                              :description => 'my group')

        flavor = fog.flavors.first.id
        image  = fog.images.first.id

        server = fog.servers.new(:name       => 'test server',
                                 :flavor_ref => flavor,
                                 :image_ref  => image)

        server.security_groups = my_group

        server.save

        found_groups = server.security_groups

        returns(1) { found_groups.length }

        group = found_groups.first
        returns('my_group') { group.name }
        returns(server.connection) { group.connection }
      ensure
        unless Fog.mocking? then
          server.destroy if server

          begin
            fog.servers.get(server.id).wait_for do false end
          rescue Fog::Errors::Error
            # ignore, server went away
          end
        end

        my_group.destroy if my_group
      end
    end
  end
end

