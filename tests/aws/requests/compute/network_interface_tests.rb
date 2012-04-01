Shindo.tests('Fog::Compute[:aws] | network interface requests', ['aws']) do

  @network_interface_format = {
    'networkInterfaceId' => String,
    'subnetId'           => String,
    'vpcId'              => String,
    'availabilityZone'   => String,
    'description'        => Fog::Nullable::String,
    'ownerId'            => String,
    'requesterId'        => Fog::Nullable::String,
    'requesterManaged'   => String,
    'status'             => String,
    'macAddress'         => String,
    'privateIpAddress'   => String,
    'privateDnsName'     => Fog::Nullable::String,
    'sourceDestCheck'    => Fog::Boolean,
    'groupSet'           => Fog::Nullable::Hash,
    'attachment'         => Hash,
    'association'        => Hash,
    'tagSet'             => Hash
  }

  @network_interface_create_format = {
    'networkInterface' => @network_interface_format,
    'requestId' => String
  }

  @network_interfaces_format = {
    'requestId'           => String,
    'networkInterfaceSet' => [ @network_interface_format ]
  }

  @attach_network_interface_format = {
    'requestId'    => String,
    'attachmentId' => String
  }

  tests('success') do
    # Create environment
    @vpc            = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')
    @subnet         = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.10.16/28')
    @security_group = Fog::Compute[:aws].security_groups.create('name' => 'sg_name', 'description' => 'sg_desc', 'vpc_id' => @vpc.id)
    
    @subnet_id         = @subnet.subnet_id
    @security_group_id = @security_group.group_id

    DESCRIPTION = "Small and green"

    tests("#create_network_interface(#{@subnet_id})").formats(@network_interface_create_format) do
      data = Fog::Compute[:aws].create_network_interface(@subnet_id).body
      @nic_id = data['networkInterface']['networkInterfaceId']
      data
    end

    # Describe network interfaces
    tests('#describe_network_interfaces').formats(@network_interfaces_format) do
      Fog::Compute[:aws].describe_network_interfaces.body
    end

    # Describe network interface attribute
    tests("#describe_network_interface_attribute(#{@nic_id}, 'description')").returns(nil) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic_id, 'description').body['description']
    end

    # test describe of all supported attributes
    [ 'description', 'groupSet', 'sourceDestCheck', 'attachment'].each do |attrib|
      tests("#describe_network_interface_attribute(#{@nic_id}, #{attrib})").returns(@nic_id) do
        Fog::Compute[:aws].describe_network_interface_attribute(@nic_id, attrib).body['networkInterfaceId']
      end
    end

    # Modify network interface description attribute
    tests("#modify_network_interface_attribute(#{@nic_id}, 'description', '#{DESCRIPTION}')").returns(true) do
      Fog::Compute[:aws].modify_network_interface_attribute(@nic_id, 'description', DESCRIPTION).body["return"]
    end

    # Describe network interface attribute again
    tests("#describe_network_interface_attribute(#{@nic_id}, 'description')").returns(DESCRIPTION) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic_id, 'description').body["description"]
    end

    # Restore network interface description attribute
    tests("#modify_network_interface_attribute(#{@nic_id}, 'description', '')").returns(true) do
      Fog::Compute[:aws].modify_network_interface_attribute(@nic_id, 'description', '').body["return"]
    end

    # Check modifying the group set
    tests("#modify_network_interface_attribute(#{@nic_id}, 'groupSet', [#{@security_group_id}])").returns(true) do
      Fog::Compute[:aws].modify_network_interface_attribute(@nic_id, 'groupSet', [@security_group_id]).body["return"]
    end
    tests("#describe_network_interface_attribute(#{@nic_id}, 'groupSet')").returns({ @security_group_id => "sg_name" }) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic_id, 'groupSet').body["groupSet"]
    end

    # Check modifying the source dest check (and reset)
    tests("#modify_network_interface_attribute(#{@nic_id}, 'sourceDestCheck', false)").returns(true) do
      Fog::Compute[:aws].modify_network_interface_attribute(@nic_id, 'sourceDestCheck', false).body["return"]
    end
    tests("#describe_network_interface_attribute(#{@nic_id}, 'sourceDestCheck')").returns(false) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic_id, 'sourceDestCheck').body["sourceDestCheck"]
    end
    tests("#reset_network_interface_attribute(#{@nic_id}, 'sourceDestCheck')").returns(true) do
      Fog::Compute[:aws].reset_network_interface_attribute(@nic_id, 'sourceDestCheck').body["return"]
    end
    tests("#describe_network_interface_attribute(#{@nic_id}, 'sourceDestCheck')").returns(true) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic_id, 'sourceDestCheck').body["sourceDestCheck"]
    end

    # Only test attach/modify attachment/detach if we are mocking since we are using a fake instance id
    if Fog.mocking?
      @instance_id = "i-11223344"

      # attach
      tests('#attach_network_interface').formats(@attach_network_interface_format) do
        data = Fog::Compute[:aws].attach_network_interface(@nic_id, @instance_id, 1).body
        @attachment_id = data['attachmentId']
        data
      end

      # Check modifying the attachment
      attach_attr = {
        'attachmentId'        => @attachment_id,
        'deleteOnTermination' => true
      }
      tests("#modify_network_interface_attribute(#{@nic_id}, 'attachment', #{attach_attr})").returns(true) do
        Fog::Compute[:aws].modify_network_interface_attribute(@nic_id, 'attachment', attach_attr).body["return"]
      end

      # detach
      tests('#detach_network_interface').returns(true) do
        Fog::Compute[:aws].detach_network_interface(@attachment_id).body["return"]
      end
    end


    # Create network interface with arguments
    options = {
      "PrivateIpAddress" => "10.0.10.23",
      "Description"      => DESCRIPTION,
      "GroupSet"         => [@security_group_id]
    }
    tests("#create_network_interface(#{@subnet_id}), #{options}").returns("10.0.10.23") do
      data = Fog::Compute[:aws].create_network_interface(@subnet_id, options).body
      @nic2_id = data['networkInterface']['networkInterfaceId']
      data['networkInterface']['privateIpAddress']
    end

    # Check assigned values
    tests("#describe_network_interface_attribute(#{@nic2_id}, 'description')").returns(DESCRIPTION) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic2_id, 'description').body["description"]
    end
    tests("#describe_network_interface_attribute(#{@nic2_id}, 'groupSet'')").returns({ @security_group_id => "sg_name"}) do
      Fog::Compute[:aws].describe_network_interface_attribute(@nic2_id, 'groupSet').body["groupSet"]
    end

    # Delete network interfaces
    tests("#delete_network_interface('#{@nic2_id}')").formats(AWS::Compute::Formats::BASIC) do
     Fog::Compute[:aws].delete_network_interface(@nic2_id).body
    end
    tests("#delete_network_interface('#{@nic_id}')").formats(AWS::Compute::Formats::BASIC) do
     Fog::Compute[:aws].delete_network_interface(@nic_id).body
    end

    # Clean up resources
    @security_group.destroy
    @subnet.destroy
    @vpc.destroy
  end
end
