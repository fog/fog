Shindo.tests("Fog::Compute[:hp] | volume requests", ['hp', 'compute', 'volumes']) do

  @list_volume_attachments_format = {
    'volumeAttachments' => [{
      'device'   => String,
      'serverId' => Integer,
      'id'       => Integer,
      'volumeId' => Integer
    }]
  }

  @volume_attachment_format = {
    'volumeAttachment' => {
      "volumeId" => Integer,
      "id"       => Integer
    }
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  @server = Fog::Compute[:hp].servers.create(:name => 'fogservoltests', :flavor_id => 100, :image_id => @base_image_id)
  @server.wait_for { ready? }

  tests('success') do
    response = HP[:block_storage].create_volume('fogvoltest', 'fogvoltest desc', 1)
    @volume_id = response.body['volume']['id']
    @device = "\/dev\/sdf"

    HP[:block_storage].volumes.get(@volume_id).wait_for { ready? }
    tests("#attach_volume(#{@server.id}, #{@volume_id}, #{@device}").formats(@volume_attachment_format) do
      Fog::Compute[:hp].attach_volume(@server.id, @volume_id, @device).body
    end

    HP[:block_storage].volumes.get(@volume_id).wait_for { in_use? } unless Fog.mocking?
    tests("#detach_volume(#{@server.id}, #{@volume_id}").succeeds do
      Fog::Compute[:hp].detach_volume(@server.id, @volume_id)
    end

    HP[:block_storage].volumes.get(@volume_id).wait_for { ready? }
    tests("#list_server_volumes(#{@server.id})").formats(@list_volume_attachments_format) do
      Fog::Compute[:hp].list_server_volumes(@server.id).body
    end

  end

  tests('failure') do

    tests("#list_server_volumes(0)").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].list_server_volumes(0)
    end

    tests("#attach_volume(#{@server.id}, 0, #{@device})").raises(Fog::Compute::HP::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:hp].attach_volume(@server.id, 0, @device)
    end

    tests("#attach_volume(0, #{@volume_id}, #{@device})").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].attach_volume(0, @volume_id, @device)
    end

    tests("#detach_volume(#{@server.id}, 0)").raises(Fog::Compute::HP::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:hp].detach_volume(@server.id, 0)
    end

    tests("#detach_volume(0, #{@volume_id})").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].detach_volume(0, @volume_id)
    end

  end

  HP[:block_storage].delete_volume(@volume_id)
  Fog::Compute[:hp].delete_server(@server.id)

end
