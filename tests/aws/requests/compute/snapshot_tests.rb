Shindo.tests('Fog::Compute[:aws] | snapshot requests', ['aws']) do

  @snapshot_format = {
    'description' => Fog::Nullable::String,
    'ownerId'     => String,
    'progress'    => String,
    'snapshotId'  => String,
    'startTime'   => Time,
    'status'      => String,
    'volumeId'    => String,
    'volumeSize'  => Integer
  }

  @snapshots_format = {
    'requestId'   => String,
    'snapshotSet' => [@snapshot_format.merge('tagSet' => {})]
  }

  @volume = Fog::Compute[:aws].volumes.create(:availability_zone => 'us-east-1a', :size => 1)

  tests('success') do

    @snapshot_id = nil

    tests("#create_snapshot(#{@volume.identity})").formats(@snapshot_format.merge('progress' => NilClass, 'requestId' => String)) do
      data = Fog::Compute[:aws].create_snapshot(@volume.identity).body
      @snapshot_id = data['snapshotId']
      data
    end

    Fog.wait_for { Fog::Compute[:aws].snapshots.get(@snapshot_id) }
    Fog::Compute[:aws].snapshots.get(@snapshot_id).wait_for { ready? }

    tests("#describe_snapshots").formats(@snapshots_format) do
      Fog::Compute[:aws].describe_snapshots.body
    end

    tests("#describe_snapshots('snapshot-id' => '#{@snapshot_id}')").formats(@snapshots_format) do
      Fog::Compute[:aws].describe_snapshots('snapshot-id' => @snapshot_id).body
    end

    tests("#delete_snapshots(#{@snapshot_id})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_snapshot(@snapshot_id).body
    end

  end
  tests('failure') do

    tests("#delete_snapshot('snap-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].delete_snapshot('snap-00000000')
    end

  end

  @volume.destroy

end
