Shindo.tests('Fog::Compute[:ibm] | instance requests', ['ibm']) do
  
  @instance_format = {
    'name'          => String,
    'location'      => String,
    'keyName'       => String,
    'primaryIP'     => {
      'type'        => Integer,
      'ip'          => String,
      'hostname'    => String,
    },
    'productCodes'  => Array,
    'requestId'     => String,
    'imageId'       => String,
    'launchTime'    => Integer,
    'id'            => String,
    'volumes'       => Array,
    'root-only'     => String,
    'instanceType'  => String,
    'diskSize'      => String,
    'requestName'   => String,
    'secondaryIP'   => Array,
    'status'        => Integer,
    'software'      => Array,
    'expirationTime'=> Integer,
    'owner'         => String
  }
  
  @instances_format = {
    'instances' => [ @instance_format ]
  }
  
  tests('success') do

    @instance_id    = nil
    @name           = "fog test instance"
    @image_id       = "20018425"
    @instance_type  = "COP32.1/2048/60"
    @location       = "101"
    @public_key     = "test"
    @expiration_time= (Time.now.tv_usec + 10000).to_f * 1000 
    @options        = {}

    tests("#create_instance('#{@name}', '#{@image_id}', '#{@instance_type}', '#{@location}', '#{@public_key}', options)").formats(@instances_format) do
      response = Fog::Compute[:ibm].create_instance(@name, @image_id, @instance_type, @location, @public_key, @options).body
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
    
    tests("#restart_instance('#{@instance_id}', '#{@public_key}')") do
      returns(true) { Fog::Compute[:ibm].restart_instance(@instance_id, @public_key).body["success"] }
    end
    
    tests("#rename_instance('#{@instance_id}', '#{@name} 2')") do
      returns(true) { Fog::Compute[:ibm].rename_instance(@instance_id, @name + " 2").body["success"] }
    end

    tests("#set_instance_expiration('#{@instance_id}', '#{@expiration_time}')") do
      returns(@expiration_time) { Fog::Compute[:ibm].set_instance_expiration(@instance_id, @expiration_time).body["expirationTime"] }
    end
    
    tests("#delete_instance('#{@instance_id}')") do
      data = Fog::Compute[:ibm].delete_instance(@instance_id)
    end

  end
  
  tests('failures') do
    
    tests('#create_instance => 401') do
      response = Fog::Compute[:ibm].create_instance("FAIL: 401", "123456", "12345", "101", "invalid")
      returns("401") { response.status }      
    end
    
  end

end
