Shindo.tests('AWS::Compute | key pair requests', ['aws']) do

  tests('success') do

    @keypair_format = {
      'keyFingerprint'  => String,
      'keyMaterial'     => String,
      'keyName'         => String,
      'requestId'       => String
    }

    @keypairs_format = {
      'keySet' => [{
        'keyFingerprint' => String,
        'keyName' => String
      }],
      'requestId' => String
    }

    @key_pair_name = 'fog_key_pair'

    tests("#create_key_pair('#{@key_pair_name}')").formats(@keypair_format) do
      AWS[:compute].create_key_pair(@key_pair_name).body
    end

    tests('#describe_key_pairs').formats(@keypairs_format) do
      AWS[:compute].describe_key_pairs.body
    end

    tests("#describe_key_pairs(#{@key_pair_name})").formats(@keypairs_format) do
      AWS[:compute].describe_key_pairs(@key_pair_name).body
    end

    tests("#delete_key_pair('#{@key_pair_name}')").formats(AWS::Compute::Formats::BASIC) do
      AWS[:compute].delete_key_pair(@key_pair_name).body
    end

    tests("#delete_key_pair('not_a_key_name')").succeeds do
      AWS[:compute].delete_key_pair('not_a_key_name')
    end

  end
  tests('failure') do

    @key_pair = AWS[:compute].key_pairs.create(:name => 'fog_key_pair')

    tests("duplicate #create_key_pair('#{@key_pair.name}')").raises(Fog::AWS::Compute::Error) do
      AWS[:compute].create_key_pair(@key_pair.name)
    end

    tests("#describe_key_pair('not_a_key_name')").raises(Fog::AWS::Compute::NotFound) do
      AWS[:compute].describe_key_pairs('not_a_key_name').body
    end

    @key_pair.destroy

  end

end
