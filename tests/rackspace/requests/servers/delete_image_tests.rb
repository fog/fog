Shindo.tests('Rackspace::Servers#delete_image', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foggetserverdetails')
    @server.wait_for { ready? }
    @image = Rackspace[:servers].images.create(:server_id => @server.id)
    @image.wait_for { ready? }

    tests("#delete_image(#{@image.identity})").succeeds do
      Rackspace[:servers].delete_image(@image.identity)
    end

    @server.destroy

  end
  tests('failure') do

    tests('#delete_image(0)').raises(Excon::Errors::BadRequest) do
      Rackspace[:servers].delete_image(0)
    end

  end
end
