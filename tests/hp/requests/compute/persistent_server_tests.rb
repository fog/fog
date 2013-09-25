Shindo.tests("Fog::Compute[:hp] | persistent server requests", ['hp', 'compute']) do

  @server_format = {
    'addresses'   => Fog::Nullable::Hash,
    'flavor'      => Hash,
    'id'          => Integer,
    'links'       => [Hash],
    'hostId'      => String,
    'metadata'    => Fog::Nullable::Hash,
    'name'        => String,
    'accessIPv4'  => Fog::Nullable::String,
    'accessIPv6'  => Fog::Nullable::String,
    'progress'    => Fog::Nullable::Integer,
    'status'      => String,
    'created'     => String,
    'updated'     => String,
    'user_id'     => String,
    'tenant_id'   => String,
    'uuid'        => String,
    'config_drive' => Fog::Nullable::String,
    'security_groups' => [Hash],
    'key_name'    => Fog::Nullable::String
  }

  @volume = HP[:block_storage].volumes.create(:name => 'fogvoltests', :description => 'fog vol test desc', :size => 1)
  @volume.wait_for { ready? }

  tests('success') do

    @server_id = nil
    @server_name = "fogpersservertests"
    @block_device_mapping = [{ 'volume_size' => '',
                               'volume_id' => "#{@volume.id}",
                               'delete_on_termination' => '0',
                               'device_name' => 'vda'
                            }]

    tests("#create_persistent_server(#{@server_name}, 100, #{@block_device_mapping})").formats(@server_format.merge('adminPass' => String)) do
      data = Fog::Compute[:hp].create_persistent_server(@server_name, 100, @block_device_mapping).body['server']
      @server_id = data['id']
      data
    end

    Fog::Compute[:hp].servers.get(@server_id).wait_for { ready? }

    tests("#get_server_details(#{@server_id})").formats(@server_format) do
      Fog::Compute[:hp].get_server_details(@server_id).body['server']
    end

    tests("#delete_server(#{@server_id})").succeeds do
      Fog::Compute[:hp].delete_server(@server_id)
    end

  end

  tests('failure') do

    tests("#create_persistent_server(#{@server_name}, 100, nil)").raises(Excon::Errors::BadRequest) do
      Fog::Compute[:hp].create_persistent_server(@server_name, 100, nil)
    end

  end

  HP[:block_storage].delete_volume(@volume.id)

end
