Shindo.tests("Fog::Compute::HPV2 | volume requests", ['hp', 'v2', 'compute', 'volumes']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @list_volume_attachments_format = {
    'volumeAttachments' => [{
      'device'   => String,
      'serverId' => String,
      'id'       => String,
      'volumeId' => String
    }]
  }

  @volume_attachment_format = {
    'volumeAttachment' => {
      'device'   => String,
      'serverId' => String,
      'id'       => String,
      'volumeId' => String
    }
  }

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  @server = service.servers.create(:name => 'fogservoltests', :flavor_id => 100, :image_id => @base_image_id)
  @server.wait_for { ready? }

  tests('success') do
    response = HP[:block_storage_v2].create_volume('display_name' => 'fogvoltest', 'display_description' => 'fogvoltest desc', 'size' => 1)
    @volume_id = response.body['volume']['id']
    @device = "\/dev\/sdf"

    tests("#attach_volume(#{@server.id}, #{@volume_id}, #{@device}").formats(@volume_attachment_format) do
      service.attach_volume(@server.id, @volume_id, @device).body
    end

    tests("#list_server_volumes(#{@server.id})").formats(@list_volume_attachments_format) do
      service.list_server_volumes(@server.id).body
    end

    tests("#get_server_volume_details(#{@server.id}, #{@volume_id})").formats(@volume_attachment_format) do
      service.get_server_volume_details(@server.id, @volume_id).body
    end

    tests("#detach_volume(#{@server.id}, #{@volume_id}").succeeds do
      service.detach_volume(@server.id, @volume_id)
    end

  end

  tests('failure') do

    tests('#list_server_volumes(0)').raises(Fog::Compute::HPV2::NotFound) do
      service.list_server_volumes(0)
    end

    tests('#get_server_volume_details(0, 0)').raises(Fog::Compute::HPV2::NotFound) do
      service.get_server_volume_details(0, 0)
    end

    tests("#attach_volume(#{@server.id}, 0, #{@device})").raises(Fog::Compute::HPV2::NotFound) do
      pending if Fog.mocking?
      service.attach_volume(@server.id, 0, @device)
    end

    tests("#attach_volume(0, #{@volume_id}, #{@device})").raises(Fog::Compute::HPV2::NotFound) do
      service.attach_volume(0, @volume_id, @device)
    end

    tests("#detach_volume(#{@server.id}, 0)").raises(Fog::Compute::HPV2::NotFound) do
      pending if Fog.mocking?
      service.detach_volume(@server.id, 0)
    end

    tests("#detach_volume(0, #{@volume_id})").raises(Fog::Compute::HPV2::NotFound) do
      service.detach_volume(0, @volume_id)
    end

  end

  HP[:block_storage_v2].delete_volume(@volume_id)
  service.delete_server(@server.id)

end
