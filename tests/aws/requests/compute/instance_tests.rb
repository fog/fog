Shindo.tests('Fog::Compute[:aws] | instance requests', ['aws']) do

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
    'placement'           => {
      'availabilityZone' => String,
      'groupName' => Fog::Nullable::String,
      'tenancy' => String
    },
    'platform'            => Fog::Nullable::String,
    'privateDnsName'      => NilClass,
    # 'privateIpAddress'    => String,
    'productCodes'        => [],
    # 'ramdiskId'           => Fog::Nullable::String,
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

  @describe_reserved_instances_offerings_format = {
    'reservedInstancesOfferingsSet' => [{
      'reservedInstancesOfferingId'     => String,
      'instanceType'                    => String,
      'availabilityZone'                => String,
      'duration'                        => Integer,
      'fixedPrice'                      => Float,
      'usagePrice'                      => Float,
      'productDescription'              => String,
      'instanceTenancy'                 => String,
      'currencyCode'                    => String
    }],
    'requestId'     => String
  }

  @purchase_reserved_instances_offering_format = {
    'reservedInstancesId' => String,
    'requestId' => String
  }

  @describe_reserved_instances_format = {
    'reservedInstancesSet' => [{
      'reservedInstancesId' => String,
      'instanceType'        => String,
      'availabilityZone'    => String,
      'start'               => Time,
      'duration'            => Integer,
      'fixedPrice'          => Float,
      'usagePrice'          => Float,
      'instanceCount'       => Integer,
      'productDescription'  => String,
      'state'               => String,
      'tagSet'              => [{
        'key'                   => String,
        'value'                 => String
      }],
      'instanceTenancy'     => String,
      'currencyCode'        => String
    }],
    'requestId'     => String
  }

  @describe_instance_status_format = {
    'requestId' => String,
    'instanceStatusSet' => [{
                              'instanceId' => String,
                              'availabilityZone' => String,
                              'instanceState' => {
                                'code' => Integer,
                                'name' => String
                              },
                              'systemStatus' => {
                                'status' => String,
                                'details' => [{
                                  'name' => String,
                                  'status' => String
                                }]
                              },
                              'instanceStatus' => {
                                'status' => String,
                                'details' => [{
                                  'name' => String,
                                  'status' => String
                                }]
                              },
                              'event' => {
                                                'code' => String,
                                                'description' => String,
                                                'notBefore' => Time,
                                                'notAfter' => Time
                                              }
                            }]

  }

  tests('success') do

    @instance_id = nil
    # Use a MS Windows AMI to test #get_password_data
    @windows_ami = 'ami-62bd440b' # Amazon Public Images - Basic Microsoft Windows Server 2008 64-bit

    # Create a keypair for decrypting the password
    key_name = 'fog-test-key'
    key = Fog::Compute[:aws].key_pairs.create(:name => key_name)

    tests("#run_instances").formats(@run_instances_format) do
      data = Fog::Compute[:aws].run_instances(@windows_ami, 1, 1, 'InstanceType' => 't1.micro', 'KeyName' => key_name).body
      @instance_id = data['instancesSet'].first['instanceId']
      data
    end

    if Fog.mocking?
      # Ensure the new instance doesn't show up in mock describe_instances right away
      tests("#describe_instances").formats(@describe_instances_format) do
        body = Fog::Compute[:aws].describe_instances.body
        instance_ids = body['reservationSet'].map {|reservation| reservation['instancesSet'].map {|instance| instance['instanceId'] } }.flatten
        test("doesn't include the new instance") { !instance_ids.include?(@instance_id) }
        body
      end

      # But querying for the new instance directly should raise an error
      tests("#describe_instances('instance-id' => '#{@instance_id}')").raises(Fog::Compute::AWS::NotFound) do
        Fog::Compute[:aws].describe_instances('instance-id' => @instance_id)
      end
    end

    server = Fog::Compute[:aws].servers.get(@instance_id)
    while server.nil? do
      # It may take a moment to get the server after launching it
      sleep 0.1
      server = Fog::Compute[:aws].servers.get(@instance_id)
    end
    server.wait_for { ready? }

    tests("#describe_instances").formats(@describe_instances_format) do
       Fog::Compute[:aws].describe_instances('instance-state-name' => 'running').body
    end

    # Launch another instance to test filters
    another_server = Fog::Compute[:aws].servers.create

    tests("#describe_instances('instance-id' => '#{@instance_id}')").formats(@describe_instances_format) do
      body = Fog::Compute[:aws].describe_instances('instance-id' => @instance_id).body
      tests("returns 1 instance").returns(1) { body['reservationSet'].size }
      body
    end

    another_server.destroy

    tests("#get_console_output('#{@instance_id}')").formats(@get_console_output_format) do
      Fog::Compute[:aws].get_console_output(@instance_id).body
    end

    tests("#get_password_data('#{@instance_id}')").formats(@get_password_data_format) do
      result = Fog::Compute[:aws].get_password_data(@instance_id).body

      tests("key can decrypt passwordData").returns(true) do

        pending if Fog.mocking?

        password_data = result['passwordData']
        Fog.wait_for do
          password_data ||= Fog::Compute[:aws].get_password_data(@instance_id).body['passwordData']
        end

        decoded_password = Base64.decode64(password_data)
        pkey = OpenSSL::PKey::RSA.new(key.private_key)
        String === pkey.private_decrypt(decoded_password)
      end
      result
    end unless ENV['FASTER_TEST_PLEASE']

    key.destroy

    tests("#reboot_instances('#{@instance_id}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].reboot_instances(@instance_id).body
    end

    tests("#terminate_instances('#{@instance_id}')").formats(@terminate_instances_format) do
      Fog::Compute[:aws].terminate_instances(@instance_id).body
    end

    tests("#describe_reserved_instances_offerings").formats(@describe_reserved_instances_offerings_format) do
      @reserved_instances = Fog::Compute[:aws].describe_reserved_instances_offerings.body
      @reserved_instances
    end

    tests('#describe_instance_status').formats(@describe_instance_status_format) do
      Fog::Compute[:aws].describe_instance_status.body
    end

    if Fog.mocking?
      @reserved_instance_offering_id = @reserved_instances["reservedInstancesOfferingsSet"].first["reservedInstancesOfferingId"]
      tests("#purchase_reserved_instances_offering('#{@reserved_instance_offering_id}')").formats(@purchase_reserved_instances_offering_format) do
        Fog::Compute[:aws].purchase_reserved_instances_offering(@reserved_instance_offering_id, 1).body
      end

      tests("#describe_reserved_instances").formats(@describe_reserved_instances_format) do
        Fog::Compute[:aws].describe_reserved_instances.body
      end
    end
  end

  tests('failure') do

    tests("#get_console_output('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].get_console_output('i-00000000')
    end

    tests("#get_password_data('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].get_password_data('i-00000000')
    end

    tests("#reboot_instances('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].reboot_instances('i-00000000')
    end

    tests("#terminate_instances('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].terminate_instances('i-00000000')
    end

  end

end
