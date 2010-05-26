Shindo.tests('AWS::EC2 | availability zone requests', ['aws']) do

  tests('success') do

    tests('#describe_availability_zones').formats(AWS::EC2::Formats::AVAILABILITY_ZONES) do
      AWS[:ec2].describe_availability_zones.body
    end

    tests("#describe_availability_zones('us-east-1a')").formats(AWS::EC2::Formats::AVAILABILITY_ZONES) do
      AWS[:ec2].describe_availability_zones('us-east-1a').body
    end

  end

  tests('failure') do

    tests("#describe_availability_zones('not-a-zone')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_availability_zones('not-a-zone')
    end

  end

end
