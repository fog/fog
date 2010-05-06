Shindo.tests('Rackspace::Servers#list_flavors_detail', 'rackspace') do
  tests('success') do

    before do
      @data = Rackspace[:servers].list_flavors_detail.body['flavors']
    end

    test('has proper output format') do
      has_format(@data, [Rackspace::Servers::Formats::FLAVOR])
    end

  end
end
