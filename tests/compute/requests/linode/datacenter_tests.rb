Shindo.tests('Fog::Compute[:linode] | datacenter requests', ['linode']) do

  @datacenters_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{ 
      'DATACENTERID'  => Integer,
      'LOCATION'      => String
    }]
  })

  tests('success') do

    tests('#avail_datacenters').formats(@datacenters_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].avail_datacenters.body
    end

  end

end
