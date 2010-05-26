Shindo.tests('AWS::EC2 | region requests', ['aws']) do

  tests('success') do

    tests("#describe_regions").formats(AWS::EC2::Formats::REGIONS) do
      AWS[:ec2].describe_regions.body
    end

    tests("#describe_regions('us-east-1')").formats(AWS::EC2::Formats::REGIONS) do
      AWS[:ec2].describe_regions('us-east-1').body
    end

  end

  tests('failure') do

    tests("#describe_regions('not-a-region')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_regions('not-a-region')
    end
  end

end
