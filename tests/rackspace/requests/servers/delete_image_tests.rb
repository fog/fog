Shindo.tests('Rackspace::Servers#delete_image', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'fogdeleteimage').body['server']['id']
      @image_id = Rackspace[:servers].create_image(@server_id).body['image']['id']
    end

    after do
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

    test('has proper output format') do
      Fog.wait_for { Rackspace[:servers].get_image_details(@image_id).body['image']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_image(@image_id)
    end

  end
  tests('failure') do

    test('raises NotFound error if image does not exist') do
      has_error(Excon::Errors::NotFound) do
        Rackspace[:servers].delete_image(0)
      end
    end

  end
end
