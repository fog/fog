Shindo.tests('AWS::EC2 | availability zone requests', ['aws']) do

  @availability_zones_format = {
    'availabilityZoneInfo'  => [{
      'regionName'  => String,
      'zoneName'    => String,
      'zoneState'   => String
    }],
    'requestId'             => String
  }

  tests('success') do

    tests('#describe_availability_zones').formats(@availability_zones_format) do
      AWS[:ec2].describe_availability_zones.body
    end

    tests("#describe_availability_zones('us-east-1a')").formats(@availability_zones_format) do
      AWS[:ec2].describe_availability_zones('us-east-1a').body
    end

  end

  tests('failure') do

    tests("#describe_availability_zones('not-a-zone')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_availability_zones('not-a-zone')
    end

  end

end
