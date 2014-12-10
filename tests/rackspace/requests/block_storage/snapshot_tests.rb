Shindo.tests('Fog::Rackspace::BlockStorage | snapshot_tests', ['rackspace']) do
  timeout = Fog.mocking? ? 1 : 10

  snapshot_format = {
    'id' => String,
    'status' => String,
    'display_name' => Fog::Nullable::String,
    'display_description' => Fog::Nullable::String,
    'volume_id' => String,
    'size' => Integer,
    'created_at' => String
    }

  get_snapshot_format = {
    'snapshot' => snapshot_format
  }

  list_snapshot_format = {
    'snapshots' => [snapshot_format]
  }

  def snapshot_deleted?(service, snapshot_id)
    begin
      service.get_snapshot(snapshot_id)
      false
    rescue
      true
    end
  end

  service = Fog::Rackspace::BlockStorage.new

  tests('success') do
    volume = service.create_volume(100).body['volume']
    volume_id = volume['id']
    snapshot_id = nil

    until service.get_volume(volume_id).body['volume']['status'] == 'available'
      sleep timeout
    end

    tests("#create_snapshot(#{volume_id})").formats(get_snapshot_format) do
      service.create_snapshot(volume_id).body.tap do |b|
        snapshot_id = b['snapshot']['id']
      end
    end

    tests("#list_snapshots").formats(list_snapshot_format) do
      service.list_snapshots.body
    end

    tests("#get_snapshot(#{snapshot_id})").formats(get_snapshot_format) do
      service.get_snapshot(snapshot_id).body
    end

    until service.get_snapshot(snapshot_id).body['snapshot']['status'] == 'available' do
      sleep timeout
    end

    tests("#delete_snapshot(#{snapshot_id})").succeeds do
      service.delete_snapshot(snapshot_id)
    end

    until snapshot_deleted?(service, snapshot_id)
      sleep timeout
    end

    service.delete_volume(volume_id)
  end

  tests('failure') do
    tests("#create_snapshot('invalid')").raises(Fog::Rackspace::BlockStorage::NotFound) do
      service.create_snapshot('invalid')
    end

    tests("#get_snapshot('invalid')").raises(Fog::Rackspace::BlockStorage::NotFound) do
      service.get_snapshot('invalid')
    end
  end
end
