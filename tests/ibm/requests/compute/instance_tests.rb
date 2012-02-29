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
    @expiration_time= (Time.now.tv_usec + 10000).to_f * 1000
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

    Fog::Compute[:ibm].servers.get(@instance_id).wait_for { ready? }

    tests("#list_instances").formats(@instances_format) do
      instances = Fog::Compute[:ibm].list_instances.body
    end

    tests("#modify_instance('#{@instance_id}', 'state' => 'restart')") do
      returns(true) { Fog::Compute[:ibm].modify_instance(@instance_id, 'state' => 'restart').body["success"] }
    end

    tests("#modify_instance('#{@instance_id}', 'name' => '#{@name} 2')") do
      returns(true) { Fog::Compute[:ibm].modify_instance(@instance_id, 'name' => @name + " 2").body["success"] }
    end

    tests("#modify_instance('#{@instance_id}', 'expirationTime' => '#{@expiration_time}')") do
      returns(@expiration_time) { Fog::Compute[:ibm].modify_instance(@instance_id, 'expirationTime' => @expiration_time).body["expirationTime"] }
    end

    tests("#delete_instance('#{@instance_id}')") do
      Fog::Compute[:ibm].servers.get(@instance_id).wait_for { ready? }
      data = Fog::Compute[:ibm].delete_instance(@instance_id)
    end

    @key.wait_for { instance_ids.empty? }
    @key.destroy

  end

  tests('failures') do

    tests('#create_instance => 401') do
      response = Fog::Compute[:ibm].create_instance("FAIL: 401", "123456", "12345", "101", :key_name => "invalid")
      returns("401") { response.status }
    end

  end

end
