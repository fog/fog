Shindo.tests('Rackspace::Servers#get_image_details', 'rackspace') do
  tests('success') do

    before do
      @data = Rackspace[:servers].get_image_details(3).body['image']
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::IMAGE)
    end

  end
  tests('failure') do

    test('raises NotFound error if image does not exist') do
      has_error(Excon::Errors::NotFound) do
        Rackspace[:servers].get_image_details(0)
      end
    end

  end
end
