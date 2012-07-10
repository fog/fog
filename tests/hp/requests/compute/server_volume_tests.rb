Shindo.tests('Fog::Compute[:hp] | volume requests', ['hp', 'block_storage']) do

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
      'device'   => String,
      'volumeId' => Integer
    }
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  tests('success') do
    @server = Fog::Compute[:hp].servers.create(:name => 'fogservoltests', :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }
    response = Fog::BlockStorage[:hp].create_volume('fogvoltest', 'fogvoltest desc', 1)
    @volume_id = response.body['volume']['id']
    @device = "\/dev\/sdf"
    #Fog::BlockStorage[:hp].volumes.get(@volume_id).wait_for { ready? }

    tests("#attach_volume(#{@server.id}, #{@volume_id}, #{@device}").formats(@volume_attachment_format) do
      Fog::Compute[:hp].attach_volume(@server.id, @volume_id, @device).body
    end

    tests("#detach_volume(#{@server.id}, #{@volume_id}").succeeds do
      Fog::Compute[:hp].detach_volume(@server.id, @volume_id)
    end

    tests("#list_server_volumes(#{@server.id})").formats(@list_volume_attachments_format) do
      Fog::Compute[:hp].list_server_volumes(@server.id).body
    end

    Fog::BlockStorage[:hp].delete_volume(@volume_id)
    @server.destroy

  end

  tests('failure') do

    tests("#list_server_volumes(#{@server.id})").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].list_server_volumes(@server.id)
    end

    tests("#attach_volume(#{@server.id}, 0, #{@device})").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].attach_volume(@server.id, 0, @device)
    end

    tests("#attach_volume(0, #{@volume_id}, #{@device})").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].attach_volume(0, @volume_id, @device)
    end

    tests("#detach_volume(#{@server.id}, 0)").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].detach_volume(@server.id, 0)
    end

    tests("#detach_volume(0, #{@volume_id})").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].detach_volume(0, @volume_id)
    end

  end

end
