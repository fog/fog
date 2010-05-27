Shindo.tests('AWS::EC2 | address requests', ['aws']) do

  @addresses_format = {
    'addressesSet' => [{
      'instanceId'  => NilClass,
      'publicIp'    => String
    }],
    'requestId' => String
  }

  @server = AWS[:ec2].servers.create(:image_id => GENTOO_AMI)
  @server.wait_for { ready? }
  @ip_address = @server.ip_address

  tests('success') do

    @public_ip = nil

    tests('#allocate_address').formats({'publicIp' => String, 'requestId' => String}) do
      data = AWS[:ec2].allocate_address.body
      @public_ip = data['publicIp']
      data
    end

    tests('#describe_addresses').formats(@addresses_format) do
      AWS[:ec2].describe_addresses.body
    end

    tests("#describe_addresses('#{@public_Ip}')").formats(@addresses_format) do
      AWS[:ec2].describe_addresses(@public_ip).body
    end

    tests("#associate_addresses('#{@server.identity}', '#{@public_Ip}')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].associate_address(@server.identity, @public_ip).body
    end

    tests("#dissassociate_address('#{@public_ip}')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].disassociate_address(@public_ip).body
    end

    tests("#release_address('#{@public_ip}')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].release_address(@public_ip).body
    end

  end
  tests ('failure') do

    @address = AWS[:ec2].addresses.create

    tests("#describe_addresses('127.0.0.1')").raises(Fog::AWS::EC2::NotFound) do
      AWS[:ec2].describe_addresses('127.0.0.1')
    end

    tests("#associate_addresses('i-00000000', '#{@address.identity}')").raises(Fog::AWS::EC2::NotFound) do
      AWS[:ec2].associate_address('i-00000000', @address.identity)
    end

    tests("#associate_addresses('#{@server.identity}', '127.0.0.1')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].associate_address(@server.identity, '127.0.0.1')
    end

    tests("#associate_addresses('i-00000000', '127.0.0.1')").raises(Fog::AWS::EC2::NotFound) do
      AWS[:ec2].associate_address('i-00000000', '127.0.0.1')
    end

    tests("#disassociate_addresses('127.0.0.1') raises BadRequest error").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].disassociate_address('127.0.0.1')
    end

    tests("#release_address('127.0.0.1')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].release_address('127.0.0.1')
    end

    @address.destroy

  end

  @server.destroy

end
