Shindo.tests('AWS::EC2 | key pair requests', ['aws']) do

  tests('success') do

    @key_pair_name = 'fog_key_pair'

    tests("#create_key_pair('#{@key_pair_name}')").formats({ 'keyFingerprint' => String, 'keyMaterial' => String, 'keyName' => String, 'requestId' => String }) do
      AWS[:ec2].create_key_pair(@key_pair_name).body
    end

    tests('#describe_key_pairs').formats({ 'keySet' => [{'keyFingerprint' => String, 'keyName' => String}], 'requestId' => String }) do
      AWS[:ec2].describe_key_pairs.body
    end

    tests("#describe_key_pairs(#{@key_pair_name})").formats({ 'keySet' => [{'keyFingerprint' => String, 'keyName' => String}], 'requestId' => String }) do
      AWS[:ec2].describe_key_pairs(@key_pair_name).body
    end

    tests("#delete_key_pair('#{@key_pair_name}')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].delete_key_pair(@key_pair_name).body
    end

    tests("#delete_key_pair('not_a_key_name')").succeeds do
      AWS[:ec2].delete_key_pair('not_a_key_name')
    end

  end
  tests('failure') do

    @key_pair = AWS[:ec2].key_pairs.create(:name => 'fog_key_pair')

    tests("duplicate #create_key_pair('#{@key_pair.name}')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].create_key_pair(@key_pair.name)
    end

    tests("#describe_key_pair('not_a_key_name')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_key_pairs('not_a_key_name').body
    end

    @key_pair.destroy

  end

end
