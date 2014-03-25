Shindo.tests('Fog::Compute[:aws] | region requests', ['aws']) do

  @regions_format = {
    'regionInfo'  => [{
      'regionEndpoint'  => String,
      'regionName'      => String
    }],
    'requestId'   => String
  }

  tests('success') do

    tests("#describe_regions").formats(@regions_format) do
      Fog::Compute[:aws].describe_regions.body
    end

    tests("#describe_regions('region-name' => 'us-east-1')").formats(@regions_format) do
      Fog::Compute[:aws].describe_regions('region-name' => 'us-east-1').body
    end

    tests("#incorrect_region") do

      raises(ArgumentError, "Unknown region: world-antarctica-1") do
        Fog::Compute::AWS.new({:aws_access_key_id => 'dummykey', 
                :aws_secret_access_key => 'dummysecret', 
                :aws_session_token => 'dummytoken',
                :region => "world-antarctica-1"})
      end
      
    end

  end

end
