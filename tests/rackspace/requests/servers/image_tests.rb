Shindo.tests('Rackspace::Servers | image requests', ['rackspace']) do

  @image_format = {
    'created'   => String,
    'id'        => Integer,
    'name'      => String,
    'progress'  => Integer,
    'serverId'  => Integer,
    'status'    => String,
    'updated'   => String
  }

  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foggetserverdetails')
    @server.wait_for { ready? }
    @image_id = nil

    tests("#create_image(#{@server.id})").formats(@image_format.reject {|key,value| key == 'progress'}) do
      data = Rackspace[:servers].create_image(@server.id).body['image']
      @image_id = data['id']
      data
    end

    Rackspace[:servers].images.get(@image_id).wait_for { ready? }

    tests("#get_image_details(#{@image_id})").formats(@image_format) do
      Rackspace[:servers].get_image_details(@image_id).body['image']
    end

    tests('#list_images').formats({'images' => [Rackspace::Servers::Formats::SUMMARY]}) do
      Rackspace[:servers].list_images.body
    end

    tests('#list_images_detail').formats({'images' => [@image_format]}) do
      Rackspace[:servers].list_images_detail.body
    end

    tests("#delete_image(#{@image_id})").succeeds do
      Rackspace[:servers].delete_image(@image_id)
    end

    @server.destroy

  end

  tests('failure') do

    tests('#delete_image(0)').raises(Excon::Errors::BadRequest) do
      Rackspace[:servers].delete_image(0)
    end

    tests('#get_image_details(0)').raises(Fog::Rackspace::Servers::NotFound) do
      Rackspace[:servers].get_image_details(0)
    end

  end

end
