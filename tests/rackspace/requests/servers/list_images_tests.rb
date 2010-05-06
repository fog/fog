Shindo.tests('Rackspace::Servers#list_images', 'rackspace') do
  tests('success') do

    before do
      @data = Rackspace[:servers].list_images.body['images']
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::SUMMARY)
    end

  end
end
