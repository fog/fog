Shindo.tests('Fog::Compute[:hp] | server requests', ['hp']) do

  @server_format = {
    'addresses'   => {
      'private'   => [Hash]
    },
    'flavor'      => Hash,
    'id'          => String,
    'image'       => Hash,
    'links'       => [Hash],
    'hostId'      => String,
    'metadata'    => Fog::Nullable::Hash,
    'name'        => String,
    'accessIPv4'  => Fog::Nullable::String,
    'accessIPv6'  => Fog::Nullable::String,
    'progress'    => Fog::Nullable::Integer,
    'status'      => String,
    'user_id'     => String,
    'tenant_id'   => String,
    'key_name'    => Fog::Nullable::String
  }

  @list_servers_format = {
    'name'  => String,
    'id'    => String
  }

  @get_console_output_format = {

  }

  tests('success') do

    @server_id = nil
    @server_name = "fogservertests"

    tests("#create_server(#{@server_name}, 100, 1242)").formats(@server_format.merge('adminPass' => String)) do
      data = Fog::Compute[:hp].create_server(@server_name, 100, 1242).body['server']
      @server_id = data['id']
      data
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#get_server_details(#{@server_id})").formats(@server_format) do
      Fog::Compute[:hp].get_server_details(@server_id).body['server']
    end

    tests('#list_servers').formats({'servers' => [@list_servers_format]}) do
      Fog::Compute[:hp].list_servers.body
    end

    tests('#list_servers_detail').formats({'servers' => [@server_format]}) do
      Fog::Compute[:hp].list_servers_detail.body
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#update_server(#{@server_id}, :name => 'fogupdatedserver')").succeeds do
      Fog::Compute[:hp].update_server(@server_id, :name => 'fogupdatedserver')
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#reboot_server(#{@server_id}, 'HARD')").succeeds do
      Fog::Compute[:hp].reboot_server(@server_id, 'HARD')
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#reboot_server(#{@server_id}, 'SOFT')").succeeds do
      Fog::Compute[:hp].reboot_server(@server_id, 'SOFT')
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#change_password_server(#{@server_id}, 'new_password')").succeeds do
      Fog::Compute[:hp].change_password_server(@server_id, 'new_password')
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#get_console_output('#{@server_id}')").formats(@get_console_output_format) do
      pending
      Fog::Compute[:hp].get_console_output(@server_id).body
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#delete_server(#{@server_id})").succeeds do
      Fog::Compute[:hp].delete_server(@server_id)
    end

  end

  tests('failure') do

    tests('#delete_server(0)').raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].delete_server(0)
    end

    tests('#get_server_details(0)').raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].get_server_details(0)
    end

    tests("#update_server(0, :name => 'fogupdatedserver')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].update_server(0, :name => 'fogupdatedserver')
    end

    tests('#reboot_server(0)').raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].reboot_server(0)
    end

    tests("#change_password_server(0}, 'new_password')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].change_password_server(0, 'new_password')
    end

  end

end
