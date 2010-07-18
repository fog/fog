Shindo.tests('Linode | datacenter requests', ['linode']) do

  @datacenters_format = Linode::Formats::BASIC.merge({
    'DATA' => [{ 
      'DATACENTERID'  => Integer,
      'LOCATION'      => String
    }]
  })

  tests('success') do

    tests('#avail_datacenters').formats(@datacenters_format) do
      Linode[:linode].avail_datacenters.body
    end

  end

end
