Shindo.tests('Fog::Compute[:openstack] | server requests', ['openstack']) do

  @server_format = {
    'addresses' => Hash,
    'flavor'  => Hash,
    'hostId'    => String,
    'id'        => String,
    'image'   => Hash,
    'metadata'  => Hash,
    'name'      => String,
    'progress'  => Integer,
    'status'    => String,
    'accessIPv4' => Fog::Nullable::String,
    'accessIPv6' => Fog::Nullable::String,
    'links' => Array
  }

  tests('success') do

    @server_id = nil

    tests('#create_server("test", 1, 19)').formats(@server_format.merge('adminPass' => String)) do
      data = Fog::Compute[:openstack].create_server("test", 3, 1).body['server']
      @server_id = data['id']
      data
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    tests("#get_server_details(#{@server_id})").formats(@server_format) do
      Fog::Compute[:openstack].get_server_details(@server_id).body['server']
    end

    tests('#list_servers').formats({'servers' => [OpenStack::Compute::Formats::SUMMARY]}) do
      Fog::Compute[:openstack].list_servers.body
    end

    tests('#list_servers_detail').formats({'servers' => [@server_format]}) do
      Fog::Compute[:openstack].list_servers_detail.body
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    tests("#update_server(#{@server_id}, :name => 'fogupdatedserver')").succeeds do
      Fog::Compute[:openstack].update_server(@server_id, :name => 'fogupdatedserver')
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    tests("#reboot_server(#{@server_id}, 'HARD')").succeeds do
      Fog::Compute[:openstack].reboot_server(@server_id, 'HARD')
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

    tests("#reboot_server(#{@server_id}, 'SOFT')").succeeds do
      Fog::Compute[:openstack].reboot_server(@server_id, 'SOFT')
    end

    Fog::Compute[:openstack].servers.get(@server_id).wait_for { ready? }

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
