Shindo.tests('Rackspace::Servers#get_flavor_details', 'rackspace') do
  tests('success') do

    tests('#get_flavor_details(1)').formats(Rackspace::Servers::Formats::FLAVOR) do
      Rackspace[:servers].get_flavor_details(1).body['flavor']
    end

  end
  tests('failure') do

    tests('#get_flavor_details(0)').raises(Excon::Errors::NotFound) do
      Rackspace[:servers].get_flavor_details(0)
    end

  end
end
