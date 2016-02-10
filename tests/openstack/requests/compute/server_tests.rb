Shindo.tests('Fog::Compute[:openstack] | server requests', ['openstack']) do

  @base_server_format = {
    'id'           => String,
    'addresses'    => Hash,
    'flavor'       => Hash,
    'hostId'       => String,
    'metadata'     => Hash,
    'name'         => String,
    'progress'     => Integer,
    'status'       => String,
    'accessIPv4'   => Fog::Nullable::String,
    'accessIPv6'   => Fog::Nullable::String,
    'links'        => Array,
    'created'      => String,
    'updated'      => String,
    'user_id'      => String,
    'config_drive' => String,
  }

  @server_from_image_format = @base_server_format.merge('image' => Hash)

  @create_format = {
    'adminPass'       => String,
    'id'              => String,
    'links'           => Array,
    'security_groups' => Fog::Nullable::Array,
  }

  @reservation_format = {
    'reservation_id' => String,
  }

  @image_format = {
    'created'   => Fog::Nullable::String,
    'id'        => String,
    'name'      => String,
    'progress'  => Fog::Nullable::Integer,
    'status'    => String,
    'updated'   => String,
    'minRam'    => Integer,
    'minDisk'   => Integer,
    'server'    => Hash,
    'metadata'  => Hash,
    'links'     => Array
  }

  tests('success') do

    @image_id = get_image_ref
    @snapshot_id = nil
    @flavor_id = get_flavor_ref
    @security_group_name = get_security_group_ref

    #CREATE_SERVER_WITH_BLOCK_DEVICE_MAPPING
    tests('#create_server("test", nil , #{@flavor_id}) with a block_device_mapping').formats(@create_format, false) do
      @volume1_id = compute.create_volume('test', 'this is a test volume', 1).body["volume"]["id"]
      volume_data = {
        :delete_on_termination => true,
        :device_name           => "vda",
        :volume_id             => @volume1_id,
        :volume_size           => 1,
      }
      data = compute.create_server("test", nil, @flavor_id, "block_device_mapping" => volume_data).body['server']
      @server_id = data['id']
      data
    end

    tests("#get_server_details(#{@server_id})").formats(@base_server_format, false) do
      compute.get_server_details(@server_id).body['server']
    end

    tests("#block_device_mapping").succeeds do
      compute.servers.get(@server_id).volumes.first.id == @volume1_id
    end

    #CREATE_SERVER_WITH_BLOCK_DEVICE_MAPPING_V2
    tests('#create_server("test", nil , #{@flavor_id}) with multiple block_device_mapping_v2').formats(@create_format, false) do
      @volume2_id = compute.create_volume('test', 'this is a test volume', 1).body["volume"]["id"]
      volume_data = [{
        :boot_index            => 0,
        :uuid                  => @volume1_id,
        :device_name           => "vda",
        :source_type           => "volume",
        :destination_type      => "volume",
        :delete_on_termination => true,
        :volume_size           => 20
      }, {
        :boot_index            => 1,
        :uuid                  => @volume2_id,
        :device_name           => "vdb",
        :source_type           => "volume",
        :destination_type      => "volume",
        :delete_on_termination => true,
        :volume_size           => 10
      }]
      data = compute.create_server("test", nil, @flavor_id, "block_device_mapping_v2" => volume_data).body['server']
      @server_id = data['id']
      data
    end

    tests("#get_server_details(#{@server_id})").formats(@base_server_format, false) do
      compute.get_server_details(@server_id).body['server']
    end

    tests("#block_device_mapping_v2").succeeds do
      compute.servers.get(@server_id).volumes.collect(&:id).sort == [@volume1_id, @volume2_id].sort
    end

    #CREATE_SINGLE_FROM_IMAGE
    tests('#create_server("test", #{@image_id} , 19)').formats(@create_format, false) do
      data = Fog::Compute[:openstack].create_server("test", @image_id, @flavor_id).body['server']
      @server_id = data['id']
      data
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    tests("#get_server_details(#{@server_id})").formats(@server_from_image_format, false) do
      Fog::Compute[:openstack].get_server_details(@server_id).body['server']
    end

    #MULTI_CREATE_FROM_IMAGE
    tests('#create_server("test", #{@image_id} , 19, {"min_count" => 2, "return_reservation_id" => "True"})').formats(@reservation_format, false) do
      data = Fog::Compute[:openstack].create_server("test", @image_id, @flavor_id, {"min_count" => 2, "return_reservation_id" => "True"}).body
      @reservation_id = data['reservation_id']
      data
    end

    tests('#validate_multi_create') do
      passed = false
      @multi_create_servers = []
      if Fog.mocking?
        @multi_create_servers = [Fog::Mock.random_numbers(6).to_s, Fog::Mock.random_numbers(6).to_s]
      else
        @multi_create_servers = Fog::Compute[:openstack].list_servers_detail({'reservation_id' => @reservation_id}).body['servers'].map{|server| server['id']}
      end
      if (@multi_create_servers.size == 2)
        passed = true
      end
    end
    unless Fog.mocking?
      @multi_create_servers.each {|server|
        Fog::Compute[:openstack].servers.get(server).destroy
      }
    end

    #LIST
    #NOTE: we can remove strict=false if we remove uuid from GET /servers
    tests('#list_servers').formats({'servers' => [OpenStack::Compute::Formats::SUMMARY]}, false) do
      Fog::Compute[:openstack].list_servers.body
    end

    #DETAILS
    tests('#list_servers_detail').formats({'servers' => [@server_from_image_format]}, false) do
      Fog::Compute[:openstack].list_servers_detail.body
    end

    #CHANGE PASSWORD
    if set_password_enabled
      tests("#change_server_password(#{@server_id}, 'fogupdatedserver')").succeeds do
        Fog::Compute[:openstack].change_server_password(@server_id, 'foggy')
      end
      Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }
    end

    #UPDATE SERVER NAME
    tests("#update_server(#{@server_id}, :name => 'fogupdatedserver')").succeeds do
      Fog::Compute[:openstack].update_server(@server_id, :name => 'fogupdatedserver')
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    #ADD SECURITY GROUP
    tests("#add_security_group(#{@server_id}, #{@security_group_name})").succeeds do
      Fog::Compute[:openstack].add_security_group(@server_id, @security_group_name)
    end

    #REMOVE SECURITY GROUP
    tests("#remove_security_group(#{@server_id}, #{@security_group_name})").succeeds do
      Fog::Compute[:openstack].remove_security_group(@server_id, @security_group_name)
    end

    #CREATE IMAGE WITH METADATA
    tests("#create_image(#{@server_id}, 'fog')").formats('image' => @image_format) do
      data = Fog::Compute[:openstack].create_image(@server_id, 'fog', {"foo" => "bar"}).body
      @snapshot_id = data['image']['id']
      data
    end
    Fog::Compute[:openstack].images.get(@snapshot_id).wait_for { ready? }

    #REBUILD
    tests("#rebuild_server(#{@server_id}, #{@snapshot_id}, 'fog')").formats({'server' => @server_from_image_format}, false) do
      Fog::Compute[:openstack].rebuild_server(@server_id, @snapshot_id, 'fog', 'newpass', {"foo" => "bar"}).body
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    #RESIZE
    tests("#resize_server(#{@server_id}, #{get_flavor_ref_resize})").succeeds do
      Fog::Compute[:openstack].resize_server(@server_id, get_flavor_ref_resize)
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { self.state == 'VERIFY_RESIZE' } if not Fog.mocking?

    #RESIZE CONFIRM
    tests("#resize_confirm(#{@server_id}, #{get_flavor_ref_resize})").succeeds do
      Fog::Compute[:openstack].confirm_resize_server(@server_id)
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    #REBOOT - HARD
    tests("#reboot_server(#{@server_id}, 'HARD')").succeeds do
      Fog::Compute[:openstack].reboot_server(@server_id, 'HARD')
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    #REBOOT - SOFT
    tests("#reboot_server(#{@server_id}, 'SOFT')").succeeds do
      Fog::Compute[:openstack].reboot_server(@server_id, 'SOFT')
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    #STOP
    tests("#stop_server(#{@server_id})").succeeds do
      Fog::Compute[:openstack].stop_server(@server_id)
    end

    #START
    tests("#start_server(#{@server_id})").succeeds do
      Fog::Compute[:openstack].start_server(@server_id)
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    tests("#shelve_server(#{@server_id})").succeeds do
      Fog::Compute[:openstack].shelve_server(@server_id)
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    tests("#unshelve_server(#{@server_id})").succeeds do
      Fog::Compute[:openstack].unshelve_server(@server_id)
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    #DELETE
    tests("#delete_server(#{@server_id})").succeeds do
      Fog::Compute[:openstack].delete_server(@server_id)
    end

    #DELETE IMAGE
    tests("#delete_image(#{@snapshot_id})").succeeds do
      Fog::Compute[:openstack].delete_image(@snapshot_id)
    end

  end

  tests('failure') do

    tests('#delete_server(0)').raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].delete_server(0)
    end

    tests('#get_server_details(0)').raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].get_server_details(0)
    end

    tests("#update_server(0, :name => 'fogupdatedserver', :adminPass => 'fogupdatedserver')").raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].update_server(0, :name => 'fogupdatedserver', :adminPass => 'fogupdatedserver')
    end

    tests('#reboot_server(0)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].reboot_server(0)
    end

    tests('#start_server(0)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].start_server(0)
    end

    tests('#stop_server(0)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].stop_server(0)
    end
  end

end
