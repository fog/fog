Shindo.tests('Fog::Compute::RackspaceV2 | attachment_tests', ['rackspace']) do

  pending if Fog.mocking?

  ATTACHMENT_FORMAT = {
    'volumeAttachment' => {
      'id' => String,
      'serverId' => String,
      'volumeId' => String,
      'device' => Fog::Nullable::String
    }
  }

  LIST_ATTACHMENTS_FORMAT = {
    'volumeAttachments' => [ATTACHMENT_FORMAT]
  }

  compute_service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  block_storage_service = Fog::Rackspace::BlockStorage.new

  name = 'fog' + Time.now.to_i.to_s
  image_id = '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001' # Ubuntu 11.10
  flavor_id = '2' # 512 MB
  server_id = compute_service.create_server(name, image_id, flavor_id, 1, 1).body['server']['id']
  volume_id = block_storage_service.create_volume(1).body['volume']['id']
  device_id = '/dev/xvde'


  tests('success') do
    until compute_service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    until block_storage_service.get_volume(volume_id).body['volume']['status'] == 'available'
      sleep 10
    end

    tests("#attach_volume(#{server_id}, #{volume_id}, #{device_id})").formats(ATTACHMENT_FORMAT) do
      compute_service.attach_volume(server_id, volume_id, device_id).body
    end

    tests("#list_attachments(#{server_id})").formats(LIST_ATTACHMENTS_FORMAT) do
      compute_service.list_attachments(server_id).body
    end

    until block_storage_service.get_volume(volume_id).body['volume']['status'] == 'in-use'
      sleep 10
    end

    tests("#get_attachment(#{server_id}, #{volume_id})").formats(ATTACHMENT_FORMAT) do
      compute_service.get_attachment(server_id, volume_id).body
    end

    tests("#delete_attachment(#{server_id}, #{volume_id})").succeeds do
      compute_service.delete_attachment(server_id, volume_id)
    end
  end

  tests('failure') do
    tests("#attach_volume('', #{volume_id}, #{device_id})").raises(Fog::Compute::RackspaceV2::NotFound) do
      compute_service.attach_volume('', volume_id, device_id)
    end

    tests("#delete_attachment('', #{volume_id})").raises(Fog::Compute::RackspaceV2::NotFound) do
      compute_service.delete_attachment('', volume_id)
    end
  end
end
