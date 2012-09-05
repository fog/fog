Shindo.tests('Fog::Rackspace::BlockStorage | snapshot_tests', ['rackspace']) do

  pending if Fog.mocking?

  SNAPSHOT_FORMAT = {
    'id' => String,
    'status' => String,
    'display_name' => Fog::Nullable::String,
    'display_description' => Fog::Nullable::String,
    'volume_id' => String,
    'size' => Integer,
    'created_at' => String
  }

  GET_SNAPSHOT_FORMAT = {
    'snapshot' => SNAPSHOT_FORMAT
  }

  LIST_SNAPSHOT_FORMAT = {
    'snapshots' => [SNAPSHOT_FORMAT]
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
    volume = service.create_volume(10).body['volume']
    volume_id = volume['id']
    snapshot_id = nil

    until service.get_volume(volume_id).body['volume']['status'] == 'available'
      sleep 10
    end

    tests("#create_snapshot(#{volume_id})").formats(GET_SNAPSHOT_FORMAT) do
      service.create_snapshot(volume_id).body.tap do |b|
        snapshot_id = b['snapshot']['id']
      end
    end

    tests("#list_snapshots").formats(LIST_SNAPSHOT_FORMAT) do
      service.list_snapshots.body
    end

    tests("#get_snapshot(#{snapshot_id})").formats(GET_SNAPSHOT_FORMAT) do
      service.get_snapshot(snapshot_id).body
    end

    until service.get_snapshot(snapshot_id).body['snapshot']['status'] == 'available' do
      sleep 10
    end

    tests("#delete_snapshot(#{snapshot_id})").succeeds do
      service.delete_snapshot(snapshot_id)
    end

    until snapshot_deleted?(service, snapshot_id)
      sleep 10
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
