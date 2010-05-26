Shindo.tests('AWS::EC2 | snapshot requests', ['aws']) do

  @volume = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1)

  tests('success') do

    @snapshot_id = nil

    tests("#create_snapshot(#{@volume.identity})").formats(AWS::EC2::Formats::SNAPSHOT.merge('progress' => NilClass, 'requestId' => String)) do
      data = AWS[:ec2].create_snapshot(@volume.identity).body
      @snapshot_id = data['snapshotId']
      data
    end

    tests("#describe_snapshots").formats(AWS::EC2::Formats::SNAPSHOTS) do
      AWS[:ec2].snapshots.get(@snapshot_id).wait_for { ready? }
      AWS[:ec2].describe_snapshots.body
    end

    tests("#describe_snapshots('#{@snapshot_id}')").formats(AWS::EC2::Formats::SNAPSHOTS) do
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
