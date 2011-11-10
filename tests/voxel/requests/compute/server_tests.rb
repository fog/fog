Shindo.tests('Fog::Compute[:voxel] | server requests', ['voxel']) do

  @server_format = {
    'device'  => {
      'id'                => String,
      'last_update'       => Time
    },
    'stat'    => String
  }

  @devices_format = {
    'devices'   => [{
      'access_methods'    => [],
      'description'       => String,
      'drives'            => [{
        'position'  => Fog::Nullable::String,
        'size'      => Integer
      }],
      'id'                => String,
      'ipassignments'     => [{
        'description' => String,
        'id'          => String,
        'type'        => String,
        'value'       => String
      }],
      'label'             => String,
      'location'          => {
        'cage'      => {
          'id'    => String,
          'value' => String
        },
        'facility'  => {
          'code'  => String,
          'id'    => String,
          'value' => String
        },
        'position'  => Fog::Nullable::String,
        'rack'      => {
          'id'    => String,
          'value' => String
        },
        'row'       => {
          'id'    => String,
          'value' => String
        },
        'zone'      => {
          'id'    => String,
          'value' => String
        }
      },
      'memory'            => { 'size' => Integer },
      'model'             => {
        'id'    => String,
        'value' => String
      },
      'operating_system'  => {
        'architecture'      => Integer,
        'name'              => String
      },
      'power_consumption' => String,
      'processor'         => {
        'cores'   => Integer
      },
      'status'            => String,
      'type'              => {
        'id'    => String,
        'value' => String
      },
    }],
    'stat'  => String,
  }

  tests('success') do

    @server_id = nil
    @name = "fog.#{Time.now.to_i}"

    tests("#voxcloud_create( :hostname => '#{@name}', :disk_size => 10, :processing_cores => 1, :image_id => 55, :facility => 'LDJ1' )").formats(@server_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:voxel].voxcloud_create( :hostname => @name, :disk_size => 10, :processing_cores => 1, :image_id => 55, :facility => "LDJ1" ).body
      @server_id = data['device']['id']
      data
    end

    unless Fog.mocking?
      Fog::Compute[:voxel].servers.get(@server_id).wait_for { ready? }
    end

    tests('#devices_list').formats(@devices_format) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].devices_list.body
    end

    tests('#devices_list(@server_id)').formats(@devices_format) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].devices_list(@server_id).body
    end

    tests("#voxcloud_delete(#{@server_id})").succeeds do
      pending if Fog.mocking?
      Fog::Compute[:voxel].voxcloud_delete(@server_id)
    end

  end

  tests('failure') do
    tests('#voxcloud_delete(0)').raises(Fog::Compute::Voxel::Error) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].voxcloud_delete(0)
    end

    tests('#voxcloud_status(0)').raises(Fog::Compute::Voxel::Error) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].voxcloud_status(0)
    end

    tests('#devices_list(0)').raises(Fog::Compute::Voxel::Error) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].devices_list(0)
    end
  end

end
