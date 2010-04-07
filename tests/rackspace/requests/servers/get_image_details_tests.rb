Shindo.tests('Rackspace::Servers#get_image_details', 'rackspace') do
  tests('success') do

    before do
      @data = Rackspace[:servers].get_image_details(3).body['image']
    end

    test('has proper output format') do
      validate_format(@data, Rackspace::Servers::Formats::IMAGE)
    end

  end
  tests('failure') do

    test('raises NotFound error if image does not exist') do
      begin
        Rackspace[:servers].get_image_details(0)
        false
      rescue Excon::Errors::NotFound
        true
      end
    end

  end
end
