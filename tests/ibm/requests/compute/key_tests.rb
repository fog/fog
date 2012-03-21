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

    @key_name  = 'fog-test-key' + Time.now.to_i.to_s(32)
    @public_key = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCvVCQA6JWWCAwjUjXDFUH8wOm15slX+WJOYCPNNrW+xipvHq5zDOCnus0xfl/zjWLVDkIz+1ku0Qapd4Q2a+NyyyH09iRxmclQaZdNoj+l4RRL0TRzeJT+l9FU0e4eUYKylrEgQCkZPFVsgn8Vly9Nh/NRcBMA1BgLMiCMebPu3N3bZIVjUrVp8MB66hqAivA36zVQ4ogykTXO8XKG9Mth7yblLjcVyDq7tecSrvM/RAUkZp0Z6SHihQwdnJwqLTcBMXeV3N2VRF3TZWayOWFgTlr1M3ZL7HD3adjRFzY8lmzbOdL/L6BamwDL9nP6bnHeH5oDnUuOIsJng04BC9Ht'

    tests("#create_key('#{@key_name}')").formats(@key_format) do
      Fog::Compute[:ibm].create_key(@key_name + '-gen').body
    end

    tests("#create_key('#{@key_name}', '#{@public_key}')") do
      returns(true) { Fog::Compute[:ibm].create_key(@key_name, @public_key).body['success'] }
    end

    tests("#list_keys").formats(@keys_format) do
      Fog::Compute[:ibm].list_keys.body
    end

    tests("#get_key('#{@key_name}')").formats(@key_format) do
      Fog::Compute[:ibm].get_key(@key_name).body
    end

    tests("#set_default_key('#{@key_name}')") do
      returns(true) { Fog::Compute[:ibm].modify_key(@key_name, 'default' => true).body['success'] }
    end

    tests("#update_key('#{@key_name}', 'publicKey' => '#{@public_key}')") do
      returns(true) { Fog::Compute[:ibm].modify_key(@key_name, 'publicKey' => @public_key).body['success'] }
    end

    tests("#delete_key('#{@key_name}')") do
      returns(true) { Fog::Compute[:ibm].delete_key(@key_name).body['success'] }
    end

  end

end
