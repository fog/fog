Shindo.tests('AWS::EC2 | volume requests', ['aws']) do

  @server = AWS[:ec2].servers.create(:image_id => GENTOO_AMI)
  @server.wait_for { ready? }

  tests('success') do

    @volume_id = nil

    tests('#create_volume').formats(AWS::EC2::Formats::VOLUME) do
      data = AWS[:ec2].create_volume(@server.availability_zone, 1).body
      @volume_id = data['volumeId']
      data
    end

    tests('#describe_volumes').formats(AWS::EC2::Formats::VOLUMES) do
      AWS[:ec2].describe_volumes.body
    end

    tests("#describe_volumes(#{@volume_id})").formats(AWS::EC2::Formats::VOLUMES) do
      AWS[:ec2].describe_volumes.body
    end

    tests("#attach_volume(#{@server.identity}, #{@volume_id}, '/dev/sdh')").formats(AWS::EC2::Formats::VOLUME_ATTACHMENT) do
      AWS[:ec2].volumes.get(@volume_id).wait_for { ready? }
      AWS[:ec2].attach_volume(@server.identity, @volume_id, '/dev/sdh').body
    end

    tests("#detach_volume('#{@volume_id}')").formats(AWS::EC2::Formats::VOLUME_ATTACHMENT) do
      AWS[:ec2].volumes.get(@volume_id).wait_for { state == 'in-use' }
      AWS[:ec2].detach_volume(@volume_id).body
    end

    tests("#delete_volume('#{@volume_id}')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].volumes.get(@volume_id).wait_for { ready? }
      AWS[:ec2].delete_volume(@volume_id).body
    end

  end
  tests ('failure') do

    @volume = AWS[:ec2].volumes.create(:availability_zone => @server.availability_zone, :size => 1)

    tests("#describe_volume('vol-00000000')").raises(Excon::Errors::BadRequest) do
      AWS[:ec2].describe_volumes('vol-00000000')
    end

    tests("#attach_volume('i-00000000', '#{@volume.identity}', '/dev/sdh')").raises(Excon::Errors::BadRequest) do
      AWS[:ec2].attach_volume('i-00000000', @volume.identity, '/dev/sdh')
    end

    tests("#attach_volume('#{@server.identity}', 'vol-00000000', '/dev/sdh')").raises(Excon::Errors::BadRequest) do
      AWS[:ec2].attach_volume(@server.identity, 'vol-00000000', '/dev/sdh')
    end

    tests("#detach_volume('vol-00000000')").raises(Excon::Errors::BadRequest) do
      AWS[:ec2].detach_volume('vol-00000000')
    end

    tests("#delete_volume('vol-00000000')").raises(Excon::Errors::BadRequest) do
      AWS[:ec2].delete_volume('vol-00000000')
    end

    @volume.destroy

  end

  @server.destroy

end
