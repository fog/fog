Shindo.tests('Fog::Compute[:aws] | address requests', ['aws']) do

  @addresses_format = {
    'addressesSet' => [{
      'instanceId'  => NilClass,
      'publicIp'    => String
    }],
    'requestId' => String
  }

  @server = Fog::Compute[:aws].servers.create
  @server.wait_for { ready? }
  @ip_address = @server.public_ip_address

  tests('success') do

    @public_ip = nil

    tests('#allocate_address').formats({'publicIp' => String, 'requestId' => String}) do
      data = Fog::Compute[:aws].allocate_address.body
      @public_ip = data['publicIp']
      data
    end

    tests('#describe_addresses').formats(@addresses_format) do
      Fog::Compute[:aws].describe_addresses.body
    end

    tests("#describe_addresses('public-ip' => #{@public_ip}')").formats(@addresses_format) do
      Fog::Compute[:aws].describe_addresses('public-ip' => @public_ip).body
    end

    tests("#associate_addresses('#{@server.identity}', '#{@public_ip}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].associate_address(@server.identity, @public_ip).body
    end

    tests("#dissassociate_address('#{@public_ip}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].disassociate_address(@public_ip).body
    end

    tests("#release_address('#{@public_ip}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].release_address(@public_ip).body
    end

  end
  tests('failure') do

    @address = Fog::Compute[:aws].addresses.create

    tests("#associate_addresses('i-00000000', '#{@address.identity}')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].associate_address('i-00000000', @address.identity)
    end

    tests("#associate_addresses('#{@server.identity}', '127.0.0.1')").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].associate_address(@server.identity, '127.0.0.1')
    end

    tests("#associate_addresses('i-00000000', '127.0.0.1')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].associate_address('i-00000000', '127.0.0.1')
    end

    tests("#disassociate_addresses('127.0.0.1') raises BadRequest error").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].disassociate_address('127.0.0.1')
    end

    tests("#release_address('127.0.0.1')").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].release_address('127.0.0.1')
    end

    @address.destroy

  end

  @server.destroy

end
