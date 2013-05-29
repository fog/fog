Shindo.tests("Fog::Compute::HPV2 | persistent server requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @server_format = {
    'addresses'   => Fog::Nullable::Hash,
    'flavor'      => Hash,
    'id'          => String,
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
    'config_drive' => Fog::Nullable::String,
    'security_groups' => [Hash],
    'key_name'    => Fog::Nullable::String
  }

  @volume = HP[:block_storage_v2].volumes.create(:name => 'fogvoltests', :description => 'fog vol test desc', :size => 1)
  @volume.wait_for { ready? }

  tests('success') do

    @server_id = nil
    @server_name = 'fogpersservertests'
    @block_device_mapping = [{ 'volume_size' => '',
                               'volume_id' => "#{@volume.id}",
                               'delete_on_termination' => '0',
                               'device_name' => 'vda'
                            }]

    tests("#create_persistent_server(#{@server_name}, 101, #{@block_device_mapping})").formats(@server_format.merge('adminPass' => String)) do
      data = service.create_persistent_server(@server_name, 101, @block_device_mapping).body['server']
      @server_id = data['id']
      data
    end

    service.servers.get(@server_id).wait_for { ready? }

    tests("#get_server_details(#{@server_id})").formats(@server_format) do
      service.get_server_details(@server_id).body['server']
    end

    tests("#delete_server(#{@server_id})").succeeds do
      service.delete_server(@server_id)
    end

  end

  tests('failure') do

    tests("#create_persistent_server(#{@server_name}, 101, nil)").raises(Excon::Errors::BadRequest) do
      service.create_persistent_server(@server_name, 101, nil)
    end

  end

  HP[:block_storage_v2].delete_volume(@volume.id)

end
