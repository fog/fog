Shindo.tests('AWS::Compute | availability zone requests', ['aws']) do

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
      AWS[:compute].describe_availability_zones.body
    end

    tests("#describe_availability_zones('us-east-1a')").formats(@availability_zones_format) do
      AWS[:compute].describe_availability_zones('us-east-1a').body
    end

  end

  tests('failure') do

    tests("#describe_availability_zones('us-east-1e')").raises(Fog::AWS::Compute::Error) do
      AWS[:compute].describe_availability_zones('us-east-1e')
    end

  end

end
