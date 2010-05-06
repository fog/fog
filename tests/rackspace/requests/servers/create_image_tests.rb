Shindo.tests('Rackspace::Servers#create_image', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'fogcreateimage').body['server']['id']
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      @data = Rackspace[:servers].create_image(@server_id).body['image']
      @image_id = @data['id']
    end

    after do
      Rackspace[:servers].delete_server(@server_id)
      Fog.wait_for { Rackspace[:servers].get_image_details(@image_id).body['image']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_image(@image_id)
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::IMAGE)
    end

  end
end
