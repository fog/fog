Shindo.tests('Rackspace::Servers#list_images_detail', 'rackspace') do
  tests('success') do

    before do
      @data = Rackspace[:servers].list_images_detail.body['images']
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::IMAGE)
    end

  end
end
