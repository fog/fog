Shindo.tests('Fog::Compute[:openstack] | server requests', ['openstack']) do

  @server_format = {
    'id'         => String,
    'addresses'  => Hash,
    'flavor'     => Hash,
    'hostId'     => String,
    'image'      => Hash,
    'metadata'   => Hash,
    'name'       => String,
    'progress'   => Integer,
    'status'     => String,
    'accessIPv4' => Fog::Nullable::String,
    'accessIPv6' => Fog::Nullable::String,
    'links' => Array
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

    @image_id = Fog::Compute[:openstack].images[0].id
    @snapshot_id = nil
    @flavor_id = 2

    tests('#create_server("test", #{@image_id} , 19)').formats(@server_format.merge('adminPass' => String), false) do
      data = Fog::Compute[:openstack].create_server("test", @image_id, @flavor_id).body['server']
      @server_id = data['id']
      data
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    #CREATE
    tests("#get_server_details(#{@server_id})").formats(@server_format, false) do
      Fog::Compute[:openstack].get_server_details(@server_id).body['server']
    end

    #LIST
    #NOTE: we can remove strict=false if we remove uuid from GET /servers
    tests('#list_servers').formats({'servers' => [OpenStack::Compute::Formats::SUMMARY]}, false) do
      Fog::Compute[:openstack].list_servers.body
    end

    #DETAILS
    tests('#list_servers_detail').formats({'servers' => [@server_format]}, false) do
      Fog::Compute[:openstack].list_servers_detail.body
    end

    #CHANGE PASSWORD
    tests("#change_password_server(#{@server_id}, 'fogupdatedserver')").succeeds do
      Fog::Compute[:openstack].change_password_server(@server_id, 'foggy')
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    #UPDATE SERVER NAME
    tests("#update_server(#{@server_id}, :name => 'fogupdatedserver')").succeeds do
      Fog::Compute[:openstack].update_server(@server_id, :name => 'fogupdatedserver')
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    #CREATE IMAGE WITH METADATA
    tests("#create_image(#{@server_id}, 'fog')").formats('image' => @image_format) do
      data = Fog::Compute[:openstack].create_image(@server_id, 'fog', {"foo" => "bar"}).body
      @snapshot_id = data['image']['id']
      data
    end
    Fog::Compute[:openstack].images.get(@snapshot_id).wait_for { ready? }

    #REBUILD
    tests("#rebuild_server(#{@server_id}, #{@snapshot_id}, 'fog')").formats({'server' => @server_format}, false) do
      Fog::Compute[:openstack].rebuild_server(@server_id, @snapshot_id, 'fog', 'newpass', {"foo" => "bar"}).body
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? } if not Fog.mocking?

    #RESIZE
    tests("#resize_server(#{@server_id}, '3')").succeeds do
      Fog::Compute[:openstack].resize_server(@server_id, 3)
    end
    Fog::Compute[:openstack].servers.get(@server_id).wait_for { self.state == 'VERIFY_RESIZE' } if not Fog.mocking?

    #RESIZE CONFIRM
    tests("#resize_confirm(#{@server_id}, '3')").succeeds do
      Fog::Compute[:openstack].confirm_resized_server(@server_id)
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

    #DELETE
    tests("#delete_server(#{@server_id})").succeeds do
      Fog::Compute[:openstack].delete_server(@server_id)
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

  end

end
