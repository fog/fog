Shindo.tests('Rackspace::Servers#get_flavor_details', 'rackspace') do
  tests('success') do

    before do
      @data = Rackspace[:servers].get_flavor_details(1).body['flavor']
    end

    test('has proper output format') do
      validate_format(@data, Rackspace::Servers::Formats::FLAVOR)
    end

  end
  tests('failure') do

    test('raises NotFound error if flavor does not exist') do
      begin
        Rackspace[:servers].get_flavor_details(0)
        false
      rescue Excon::Errors::NotFound
        true
      end
    end

  end
end
