Shindo.tests('Voxel::Compute | server requests', ['voxel']) do

  @server_format = {
    :id               => Integer,
    :name             => String,
    :processing_cores => Integer,
    :image_id         => Integer,
    :facility         => String,
    :disk_size        => Integer,
    :addresses        => {
      :private  => String,
      :public   => String
    },
    :password         => String
  }

  tests('success') do

		@server_id = nil

    tests('#voxcloud_create( :name => "fog.test", :disk_size => 10, :processing_cores => 1, :image_id => 16, :facility => "LDJ1" )').formats([@server_format]) do
      data = Voxel[:compute].voxcloud_create( :name => "fog.test", :disk_size => 10, :processing_cores => 1, :image_id => 16, :facility => "LDJ1" )
      @server_id = data.first[:id]
      data
    end

    Voxel[:compute].servers.get(@server_id).wait_for { ready? }

    tests('#devices_list').formats([ @server_format ]) do
      Voxel[:compute].devices_list
    end

    tests('#devices_list(@server_id)').formats([ @server_format ]) do
      Voxel[:compute].devices_list(@server_id)
    end

    tests("#voxcloud_delete(#{@server_id})").succeeds do
      Voxel[:compute].voxcloud_delete(@server_id)
    end

  end

  tests('failure') do
    tests('#voxcloud_delete(0)').raises(Fog::Voxel::Compute::NotFound) do
      Voxel[:compute].voxcloud_delete(0)
    end

    tests('#voxcloud_status(0)').raises(Fog::Voxel::Compute::NotFound) do
      Voxel[:compute].voxcloud_status(0)
    end

    tests('#devices_list(0)').raises(Fog::Voxel::Compute::NotFound) do
      Voxel[:compute].devices_list(0)
    end
  end

end
