Shindo.tests('Fog::Compute[:linode] | linodenodebalancers requests', ['linode']) do

  @linodenodebalancers_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{
      'MONTHLY'     => Float,
      'HOURLY'      => Float,
      'CONNECTIONS' => Integer
    }]
  })

  tests('success') do

    tests('#avail_nodebalancers').formats(@linodenodebalancers_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].avail_nodebalancers.body
    end

  end

end
