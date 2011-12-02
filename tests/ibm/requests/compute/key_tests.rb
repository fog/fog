Shindo.tests('Fog::Compute[:ibm] | key requests', ['ibm']) do
  
  @key_format  = {
    'default'           => Fog::Boolean,
    'instanceIds'       => Array,
    'keyMaterial'       => String,
    'keyName'           => String,
    'lastModifiedTime'  => Integer
  }
  
  @keys_format = {
    'keys'     => [ @key_format ]
  }

  tests('success') do
    
    @key_name  = "fog test key"
    @public_key = <<-EOF
    -----BEGIN RSA PUBLIC KEY-----
    MIGJAoGBAL2nePLzDy1Z2Y64/Dz5QMmJN4S9xc6D8TbiKVe5YHeuNt3fCSYDJl9x
    d/V5r2mUo4nGrEhum1ooX0rdk5CPugVxd3Tgovj87y3NRw9zAdeCB8omfrRwG4yu
    x1z+ejqX1BSKYy+KvOT2RKiuLdIiodLsps5epovQFZmlymTIg/ODAgMBAAE=
    -----END RSA PUBLIC KEY-----    
    EOF
    @public_key.gsub!(/^\s{4}/, '')
    
    tests("#create_key('#{@key_name}')").formats(@key_format) do
      Fog::Compute[:ibm].create_key(@key_name).body
    end
  
    tests("#list_keys").formats(@keys_format) do
      Fog::Compute[:ibm].list_keys.body
    end
    
    tests("#get_key('#{@key_name}')").formats(@key_format) do
      Fog::Compute[:ibm].get_key(@key_name).body
    end
    
    tests("#set_default_key('#{@key_name}')") do 
      returns(@key_name) { Fog::Compute[:ibm].set_default_key(@key_name).body }
    end
    
    tests("#update_key('#{@key_name}', '#{@public_key}')") do 
      returns(true) { Fog::Compute[:ibm].update_key(@key_name, @public_key).body['success'] }
    end    
    
    tests("#delete_key('#{@key_name}')") do
      returns(true) { Fog::Compute[:ibm].delete_key(@key_name).body['success'] }
    end

    tests("#upload_key('#{@key_name}', '#{@public_key}')") do
      returns(true) { Fog::Compute[:ibm].upload_key(@key_name, @public_key).body['success'] }
    end
  
  end

end