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
        returns(server.service) { group.service }
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


    tests('#metadata').succeeds do
      fog = Fog::Compute[:openstack]

      begin
        flavor = fog.flavors.first.id
        image  = fog.images.first.id

        server = fog.servers.new(:name       => 'test server',
                                 :metadata => {"foo" => "bar"},
                                 :flavor_ref => flavor,
                                 :image_ref  => image)

        server.save

        returns(1) { server.metadata.length }

        server.metadata.each do |datum|
          datum.value = 'foo'
          datum.save
          datum.destroy
        end

      ensure
        unless Fog.mocking? then
          server.destroy if server

          begin
            fog.servers.get(server.id).wait_for do false end
          rescue Fog::Errors::Error
            # ignore, server went away
          end
        end

      end
    end

    tests('#resize').succeeds do
      fog = Fog::Compute[:openstack]

      begin
        flavor = fog.flavors.first.id
        image  = fog.images.first.id

        server = fog.servers.new(:name       => 'test server',
                                 :flavor_ref => flavor,
                                 :image_ref  => image)

        server.save

        flavor_resize = fog.flavors[1].id
        server.resize(flavor_resize)
        server.wait_for { server.state == "VERIFY_RESIZE" } unless Fog.mocking?
        server.revert_resize
        server.wait_for { server.state == "ACTIVE" } unless Fog.mocking?
        server.resize(flavor_resize)
        server.wait_for { server.state == "VERIFY_RESIZE" } unless Fog.mocking?
        server.confirm_resize

      ensure
        unless Fog.mocking? then
          server.destroy if server

          begin
            fog.servers.get(server.id).wait_for do false end
          rescue Fog::Errors::Error
            # ignore, server went away
          end
        end
      end
    end

    tests('#volumes').succeeds do
      fog = Fog::Compute[:openstack]

      begin
        volume = fog.volumes.new(:name => 'test volume',
                                 :description => 'test volume',
                                 :size => 1)
        volume.save
        volume.wait_for { volume.status == 'available' } unless Fog.mocking?

        flavor = fog.flavors.first.id
        image  = fog.images.first.id

        server = fog.servers.new(:name       => 'test server',
                                 :flavor_ref => flavor,
                                 :image_ref  => image)

        server.save
        server.wait_for { server.state == "ACTIVE" } unless Fog.mocking?

        server.attach_volume(volume.id, '/dev/vdc')
        volume.wait_for { volume.status == 'in-use' } unless Fog.mocking?

        found_volumes = server.volumes
        returns(1) { found_volumes.length }

        volume = found_volumes.first
        returns('test volume') { volume.name }

        found_attachments = server.volume_attachments
        returns(1) { found_attachments.length }

        attachment = found_attachments.first
        returns('/dev/vdc') { attachment['device'] }

        server.detach_volume(volume.id)
        volume.wait_for { volume.status == 'available' } unless Fog.mocking?

        found_volumes = server.volumes
        returns(0) { found_volumes.length }

        found_attachments = server.volume_attachments
        returns(0) { found_attachments.length }
      ensure
        unless Fog.mocking? then
          server.destroy if server
          volume.destroy if volume

          begin
            fog.servers.get(server.id).wait_for do false end
            fog.volumes.get(volume.id).wait_for do false end
          rescue Fog::Errors::Error
            # ignore, server went away
          end
        end
      end
    end

  end
end

