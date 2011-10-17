Shindo.tests('Fog::Compute[:aws] | spot price history requests', ['aws']) do

  @spot_price_history_format = {
    'spotPriceHistorySet'   => [{
      'availabilityZone'    => String,
      'instanceType'        => String,
      'spotPrice'           => Float,
      'productDescription'  => String,
      'timestamp'           => Time
    }],
    'requestId' => String
  }

  tests('success') do

    pending # Some history data doesn't have an availability zone

    tests("#describe_spot_price_history").formats(@spot_price_history_format) do
      Fog::Compute[:aws].describe_spot_price_history.body
    end

  end

end
