Shindo.tests('AWS::Compute | instance requests', ['aws']) do

  @instance_format = {
    # 'architecture'    => String,
    'amiLaunchIndex'      => Integer,
    'blockDeviceMapping'  => [],
    'clientToken'         => Fog::Nullable::String,
    'dnsName'             => NilClass,
    'imageId'             => String,
    'instanceId'          => String,
    'instanceState'       => {'code' => Integer, 'name' => String},
    'instanceType'        => String,
    # 'ipAddress'           => String,
    'kernelId'            => Fog::Nullable::String,
    'keyName'             => Fog::Nullable::String,
    'launchTime'          => Time,
    'monitoring'          => {'state' => Fog::Boolean},
    'placement'           => {'availabilityZone' => String},
    'privateDnsName'      => NilClass,
    # 'privateIpAddress'    => String,
    'productCodes'        => [],
    'ramdiskId'           => Fog::Nullable::String,
    'reason'              => Fog::Nullable::String,
    # 'rootDeviceName'      => String,
    'rootDeviceType'      => String,
  }

  @run_instances_format = {
    'groupSet'        => [String],
    'instancesSet'    => [@instance_format],
    'ownerId'         => String,
    'requestId'       => String,
    'reservationId'   => String
  }

  @describe_instances_format = {
    'reservationSet'  => [{
      'groupSet'      => [String],
      'instancesSet'  => [@instance_format.merge(
        'architecture'      => String,
        'dnsName'           => Fog::Nullable::String,
        'ipAddress'         => Fog::Nullable::String,
        'privateDnsName'    => Fog::Nullable::String,
        'privateIpAddress'  => Fog::Nullable::String,
        'stateReason'       => Hash,
        'tagSet'            => Hash
      )],
      'ownerId'       => String,
      'reservationId' => String
    }],
    'requestId'       => String
  }

  @get_console_output_format = {
    'instanceId'  => String,
    'output'      => Fog::Nullable::String,
    'requestId'   => String,
    'timestamp'   => Time
  }

  @get_password_data_format = {
    'instanceId'   => String,
    'passwordData' => Fog::Nullable::String,
    'requestId'    => String,
    'timestamp'    => Time
  }


  @terminate_instances_format = {
    'instancesSet'  => [{
      'currentState' => {'code' => Integer, 'name' => String},
      'instanceId'    => String,
      'previousState' => {'code' => Integer, 'name' => String},
    }],
    'requestId'     => String
  }

  tests('success') do

    @instance_id = nil
    # Use a MS Windows AMI to test #get_password_data
    @windows_ami = 'ami-ee926087' # Microsoft Windows Server 2008 R2 Base 64-bit

    # Create a keypair for decrypting the password
    key_name = 'fog-test-key'
    key = AWS.key_pairs.create(:name => key_name)

    tests("#run_instances").formats(@run_instances_format) do
      data = AWS[:compute].run_instances(@windows_ami, 1, 1, 'InstanceType' => 't1.micro', 'KeyName' => key_name).body
      @instance_id = data['instancesSet'].first['instanceId']
      data
    end

    server = AWS[:compute].servers.get(@instance_id)
    while server.nil? do
      # It may take a moment to get the server after launching it
      sleep 0.1
      server = AWS[:compute].servers.get(@instance_id)
    end
    server.wait_for { ready? }

    tests("#describe_instances").formats(@describe_instances_format) do
       AWS[:compute].describe_instances.body
    end

    # Launch another instance to test filters
    another_server = AWS[:compute].servers.create

    tests("#describe_instances('instance-id' => '#{@instance_id}')").formats(@describe_instances_format) do
      body = AWS[:compute].describe_instances('instance-id' => @instance_id).body
      tests("returns 1 instance").returns(1) { body['reservationSet'].size }
      body
    end

    another_server.destroy

    tests("#get_console_output('#{@instance_id}')").formats(@get_console_output_format) do
      AWS[:compute].get_console_output(@instance_id).body
    end

    tests("#get_password_data('#{@instance_id}')").formats(@get_password_data_format) do
      result = AWS[:compute].get_password_data(@instance_id).body

      tests("key can decrypt passwordData").returns(true) do

        pending if Fog.mocking?

        password_data = result['passwordData']
        Fog.wait_for do
          password_data ||= AWS[:compute].get_password_data(@instance_id).body['passwordData']
        end

        decoded_password = Base64.decode64(password_data)
        pkey = OpenSSL::PKey::RSA.new(key.private_key)
        String === pkey.private_decrypt(decoded_password)
      end
      result
    end

    key.destroy

    tests("#reboot_instances('#{@instance_id}')").formats(AWS::Compute::Formats::BASIC) do
      AWS[:compute].reboot_instances(@instance_id).body
    end

    tests("#terminate_instances('#{@instance_id}')").formats(@terminate_instances_format) do
      AWS[:compute].terminate_instances(@instance_id).body
    end

  end

  tests('failure') do

    tests("#get_console_output('i-00000000')").raises(Fog::AWS::Compute::NotFound) do
      AWS[:compute].get_console_output('i-00000000')
    end

    tests("#get_password_data('i-00000000')").raises(Fog::AWS::Compute::NotFound) do
      AWS[:compute].get_password_data('i-00000000')
    end

    tests("#reboot_instances('i-00000000')").raises(Fog::AWS::Compute::NotFound) do
      AWS[:compute].reboot_instances('i-00000000')
    end

    tests("#terminate_instances('i-00000000')").raises(Fog::AWS::Compute::NotFound) do
      AWS[:compute].terminate_instances('i-00000000')
    end

  end

end
