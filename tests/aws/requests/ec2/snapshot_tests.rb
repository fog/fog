Shindo.tests('AWS::EC2 | snapshot requests', ['aws']) do

  @snapshot_format = {
    'description' => NilClass,
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
    'snapshotSet' => [@snapshot_format]
  }

  @volume = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1)

  tests('success') do

    @snapshot_id = nil

    tests("#create_snapshot(#{@volume.identity})").formats(@snapshot_format.merge('progress' => NilClass, 'requestId' => String)) do
      data = AWS[:ec2].create_snapshot(@volume.identity).body
      @snapshot_id = data['snapshotId']
      data
    end

    AWS[:ec2].snapshots.get(@snapshot_id).wait_for { ready? }

    tests("#describe_snapshots").formats(@snapshots_format) do
      AWS[:ec2].describe_snapshots.body
    end

    tests("#describe_snapshots('#{@snapshot_id}')").formats(@snapshots_format) do
      AWS[:ec2].describe_snapshots(@snapshot_id).body
    end

    tests("#delete_snapshots(#{@snapshot_id})").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].delete_snapshot(@snapshot_id).body
    end

  end
  tests ('failure') do

    tests("#describe_snapshot('snap-00000000')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_snapshots('snap-00000000')
    end

    tests("#delete_snapshot('snap-00000000')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].delete_snapshot('snap-00000000')
    end

  end

  @volume.destroy

end
