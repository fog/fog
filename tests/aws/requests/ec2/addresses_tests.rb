Shindo.tests('AWS::EC2', ['aws']) do

  @server = AWS[:ec2].servers.create(:image_id => GENTOO_AMI)
  @server.wait_for { ready? }

  tests('success') do

    @public_ip = nil

    test('#allocate_address') do
      @data = AWS[:ec2].allocate_address.body
      @public_ip = @data['publicIp']
      has_format(
        @data,
        {
          'publicIp'  => String,
          'requestId' => String
        }
      )
    end

    test("#describe_addresses") do
      @data = AWS[:ec2].describe_addresses.body
      has_format(@data, AWS::EC2::Formats::ADDRESSES)
    end

    test("#describe_addresses('#{@public_ip}')") do
      @data = AWS[:ec2].describe_addresses(@public_ip).body
      has_format(@data, AWS::EC2::Formats::ADDRESSES)
    end

    test("#associate_address('#{@server.identity}', '#{@public_ip}')") do
      @data = AWS[:ec2].associate_address(@server.identity, @public_ip).body
      has_format(@data, AWS::EC2::Formats::BASIC)
    end

    test("#disassociate_address('#{@public_ip}')") do
      @data = AWS[:ec2].disassociate_address(@public_ip).body
      has_format(@data, AWS::EC2::Formats::BASIC)
    end

    test("#release_address('#{@public_ip}')") do
      @data = AWS[:ec2].release_address(@public_ip).body
      has_format(@data, AWS::EC2::Formats::BASIC)
    end

  end
  tests ('failure') do

    @address = AWS[:ec2].addresses.create

    test("#describe_addresses('127.0.0.1') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].describe_addresses('127.0.0.1')
      end
    end

    test("#associate_addresses('i-00000000', '#{@address.identity}') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].associate_address('i-00000000', @address.identity)
      end
    end

    test("#associate_addresses('#{@server.identity}', '127.0.0.1') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].associate_address(@server.identity, '127.0.0.1')
      end
    end

    test("#disassociate_addresses('127.0.0.1') raises BadRequest error") do
      begin
        AWS[:ec2].disassociate_address('127.0.0.1')
        false
      rescue Excon::Errors::BadRequest
        true
      end
    end

    test("#release_address('127.0.0.1') raises BadRequest error") do
      has_error(Excon::Errors::BadRequest) do
        AWS[:ec2].release_address('127.0.0.1')
      end
    end

    @address.destroy

  end

  @server.destroy

end
