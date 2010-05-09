Shindo.tests('AWS::EC2 | volume requests', ['aws']) do

  @server = AWS[:ec2].servers.create(:image_id => GENTOO_AMI)
  @server.wait_for { ready? }

  tests('success') do

    @volume_id = nil

    test('#create_volume') do
      @data = AWS[:ec2].create_volume(@server.availability_zone, 1).body
      @volume_id = @data['volumeId']
      has_format(@data, AWS::EC2::Formats::VOLUME)
    end

    test('#describe_volumes') do
      @data = AWS[:ec2].describe_volumes.body
      has_format(@data, AWS::EC2::Formats::VOLUMES)
    end

    test("#describe_volumes(#{@volume_id})") do
      @data = AWS[:ec2].describe_volumes.body
      has_format(@data, AWS::EC2::Formats::VOLUMES)
    end

    test("#attach_volume(#{@server.identity}, #{@volume_id}, '/dev/sdh')") do
      @data = AWS[:ec2].attach_volume(@server.identity, @volume_id, '/dev/sdh').body
      has_format(@data, AWS::EC2::Formats::VOLUME_ATTACHMENT)
    end

    test("#detach_volume('#{@volume_id}')") do
      AWS[:ec2].volumes.get(@volume_id).wait_for { state == 'attached' }
      @data = AWS[:ec2].detach_volume(@volume_id).body
      has_format(@data, AWS::EC2::Formats::VOLUME_ATTACHMENT)
    end

    test("#delete_volume('#{@volume_id}')") do
      AWS[:ec2].volumes.get(@volume_id).wait_for { ready? }
      @data = AWS[:ec2].delete_volume(@volume_id).body
      has_format(@data, AWS::EC2::Formats::BASIC)
    end

  end
  tests ('failure') do

    @volume = AWS[:ec2].volumes.create(:availability_zone => @server.availability_zone, :size => 1)

    test("#describe_volume('vol-00000000') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].describe_volumes('vol-00000000')
      end
    end

    test("#attach_volume('i-00000000', '#{@volume.identity}', '/dev/sdh') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].attach_volume('i-00000000', @volume.identity, '/dev/sdh')
      end
    end

    test("#attach_volume('#{@server.identity}', 'vol-00000000', '/dev/sdh') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].attach_volume(@server.identity, 'vol-00000000', '/dev/sdh')
      end
    end

    test("#detach_volume('vol-00000000') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].detach_volume('vol-00000000')
      end
    end

    test("#delete_volume('vol-00000000') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].delete_volume('vol-00000000')
      end
    end

    @volume.destroy

  end

  @server.destroy

end
