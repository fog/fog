Shindo.tests('Fog::Compute[:ibm] | instance requests', ['ibm']) do

  @instance_format = {
    'name'          => String,
    'location'      => String,
    'keyName'       => String,
    'primaryIP'     => {
      'vlan'        => Fog::Nullable::String,
      'type'        => Integer,
      'ip'          => String,
      'hostname'    => String,
    },
    'productCodes'  => Array,
    'requestId'     => String,
    'imageId'       => String,
    'launchTime'    => Integer,
    'id'            => String,
    'ip'            => Fog::Nullable::String,
    'volumes'       => Array,
    'root-only'     => Fog::Nullable::String,
    'isMiniEphemeral' => Fog::Nullable::String,
    'instanceType'  => String,
    'diskSize'      => Fog::Nullable::String,
    'requestName'   => String,
    'secondaryIP'   => Array,
    'status'        => Integer,
    'software'      => Array,
    'expirationTime'=> Integer,
    'owner'         => String,
  }

  @instances_format = {
    'instances' => [ @instance_format ]
  }

  tests('success') do

    @instance_id    = nil
    @name           = "fog-test-instance-" + Time.now.to_i.to_s(32)
    @image_id       = "20010001"
    @instance_type  = "COP32.1/2048/60"
    @location       = "41"
    @key_name       = "fog-test-key-" + Time.now.to_i.to_s(32)
    @key            = Fog::Compute[:ibm].keys.create(:name => @key_name)

    tests("#create_instance('#{@name}', '#{@image_id}', '#{@instance_type}', '#{@location}', :key_name => '#{@key_name}')").formats(@instances_format) do
      response = Fog::Compute[:ibm].create_instance(@name, @image_id, @instance_type, @location, :key_name => @key_name).body
      @instance_id = response['instances'][0]['id']
      response
    end

    tests("#get_instance('#{@instance_id}')").formats(@instance_format) do
      response = Fog::Compute[:ibm].get_instance(@instance_id).body
    end

    Fog::Compute[:ibm].servers.get(@instance_id).wait_for(Fog::IBM.timeout) { ready? }

    tests("#list_instances").formats(@instances_format) do
      instances = Fog::Compute[:ibm].list_instances.body
    end

    tests("#modify_instance('#{@instance_id}', 'state' => 'restart')") do
      returns(true) { Fog::Compute[:ibm].modify_instance(@instance_id, 'state' => 'restart').body["success"] }
    end

    tests("#modify_instance('#{@instance_id}', 'name' => '#{@name} 2')") do
      returns(true) { Fog::Compute[:ibm].modify_instance(@instance_id, 'name' => @name + " 2").body["success"] }
    end

    @expiration_time = (Time.now.to_i + 10) * 1000

    tests("#modify_instance('#{@instance_id}', 'expirationTime' => '#{@expiration_time}')") do
      returns(@expiration_time) { Fog::Compute[:ibm].modify_instance(@instance_id, 'expirationTime' => @expiration_time).body["expirationTime"] }
    end

    tests("#delete_instance('#{@instance_id}')") do
      if Fog::Compute[:ibm].servers.get(@instance_id).wait_for(Fog::IBM.timeout) { ready? }
        data = Fog::Compute[:ibm].delete_instance(@instance_id)
      else
        pending
      end
    end

    if @key.wait_for(Fog::IBM.timeout) { instance_ids.empty? }
      @key.destroy
    else
      pending
    end

  end

  tests('failures') do

    tests('#create_instance => 412') do
      raises(Excon::Errors::PreconditionFailed) do
        Fog::Compute[:ibm].create_instance("FAIL: 412", @image_id, @instance_type, @location, :key_name => "invalid")
      end
    end

  end

end
