Shindo.tests('Fog::Compute[:cloudsigma] | server model', ['cloudsigma']) do
  service = Fog::Compute[:cloudsigma]
  servers = Fog::Compute[:cloudsigma].servers
  server_create_args =  {:name => 'fogtest', :cpu => 2000, :mem => 512*1024**2, :vnc_password => 'myrandompass'}

  model_tests(servers, server_create_args, true) do
    tests('start_stop').succeeds do
      @instance.start

      @instance.wait_for(timeout=60)  { status == 'running' }

      @instance.stop

      @instance.wait_for(timeout=60)  { status == 'stopped' }
    end

    tests('attach_dhcp_nic').succeeds do
      @instance.add_public_nic()
      @instance.save

      @instance.reload

      returns('dhcp') { @instance.nics.first.ip_v4_conf.conf }
      succeeds {/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/ === @instance.nics.first.mac}
    end

    tests('attach_vlan') do
      if Fog.mocking?
        # Do not buy subscription with real account
        service.subscriptions.create({:period=>"1 month", :amount=>1, :resource=>"vlan"})
        vlan = service.vlans.first
        vlan.meta['name'] = 'fog-test'
        vlan.save
      end

      vlan = service.vlans.find {|vlan| vlan.meta['name'] == 'fog-test'}

      # Skip if there is no vlan marked for fog tests
      pending unless vlan

      @instance.add_private_nic(vlan)
      @instance.save

      @instance.reload

      returns(vlan.uuid) { @instance.nics.last.vlan['uuid'] || @instance.nics.last.vlan}
      succeeds {/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/ === @instance.nics.last.mac}
    end

    tests('attach_volume') do
      volume_create_args = {:name => 'fogservermodeltest', :size => 1000**3, :media => :cdrom}
      v = service.volumes.create(volume_create_args)
      volume_uuid = v.uuid

      @instance.mount_volume(v)
      @instance.save
      @instance.reload

      returns(volume_uuid) { @instance.volumes.first.volume }

      @instance.unmount_volume(v)
      @instance.save
      @instance.reload

      succeeds { @instance.volumes.empty? }

      v.delete

    end
  end

end
