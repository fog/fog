Shindo.tests('Rackspace::Servers#create_image', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foggetserverdetails')
    @server.wait_for { ready? }
    @image_id = nil

    tests("#create_image(#{@server.id})").formats(Rackspace::Servers::Formats::IMAGE.reject {|key,value| key == 'progress'}) do
      data = Rackspace[:servers].create_image(@server.id).body['image']
      @image_id = data['id']
      data
    end

    @image = Rackspace[:servers].images.get(@image_id)
    @image.wait_for { ready? }
    @image.destroy
    @server.destroy

  end
end
