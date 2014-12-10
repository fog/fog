Shindo.tests('Fog::Compute::RackspaceV2 | attachment_tests', ['rackspace']) do
  compute_service       = Fog::Compute::RackspaceV2.new
  block_storage_service = Fog::Rackspace::BlockStorage.new
  image_id              = rackspace_test_image_id(compute_service)
  flavor_id             = rackspace_test_flavor_id(compute_service)

  attachment_format = {
    'volumeAttachment' => {
      'id' => String,
      'serverId' => String,
      'volumeId' => String,
      'device' => Fog::Nullable::String
    }
  }

  list_attachments_format = {
    'volumeAttachments' => [attachment_format['volumeAttachment']]
  }

  name = 'fog' + Time.now.to_i.to_s
  image_id = image_id
  flavor_id = flavor_id
  server_id = compute_service.create_server(name, image_id, flavor_id, 1, 1).body['server']['id']
  volume_id = block_storage_service.create_volume(100).body['volume']['id']
  device_id = '/dev/xvde'

  tests('success') do
    wait_for_request("Waiting for server to become ready") do
      compute_service.get_server(server_id).body['server']['status'] == 'ACTIVE'
    end

    wait_for_request("Waiting for Volume to be ready") do
      block_storage_service.get_volume(volume_id).body['volume']['status'] == 'available'
    end

    tests("#attach_volume(#{server_id}, #{volume_id}, #{device_id})").formats(attachment_format) do
      compute_service.attach_volume(server_id, volume_id, device_id).body
    end

    tests("#list_attachments(#{server_id})").formats(list_attachments_format) do
      compute_service.list_attachments(server_id).body
    end

    wait_for_request("Waiting for Volume to be ready") do
      block_storage_service.get_volume(volume_id).body['volume']['status'] == 'in-use'
    end

    tests("#get_attachment(#{server_id}, #{volume_id})").formats(attachment_format) do
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
