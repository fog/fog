Shindo.tests('AWS::EC2 | snapshot requests', ['aws']) do

  @volume = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1)

  tests('success') do

    @snapshot_id = nil

    test("#create_snapshot(#{@volume.identity})") do
      @data = AWS[:ec2].create_snapshot(@volume.identity).body
      @snapshot_id = @data['snapshotId']
      has_format(@data, AWS::EC2::Formats::SNAPSHOT.merge('progress' => NilClass, 'requestId' => String))
    end

    test("#describe_snapshots") do
      AWS[:ec2].snapshots.get(@snapshot_id).wait_for { ready? }
      @data = AWS[:ec2].describe_snapshots.body
      has_format(@data, AWS::EC2::Formats::SNAPSHOTS)
    end

    test("#describe_snapshots('#{@snapshot_id}')") do
      @data = AWS[:ec2].describe_snapshots(@snapshot_id).body
      has_format(@data, AWS::EC2::Formats::SNAPSHOTS)
    end

    test("#delete_snapshots(#{@snapshot_id})") do
      @data = AWS[:ec2].delete_snapshot(@snapshot_id).body
      has_format(@data, AWS::EC2::Formats::BASIC)
    end

  end
  tests ('failure') do

    test("#describe_snapshot('snap-00000000') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].describe_snapshots('snap-00000000')
      end
    end

    test("#delete_snapshot('snap-00000000') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].delete_snapshot('snap-00000000')
      end
    end

  end

  @volume.destroy

end
