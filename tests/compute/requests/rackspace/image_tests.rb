Shindo.tests('Fog::Compute[:rackspace] | image requests', ['rackspace']) do

  @image_format = {
    'created'   => Fog::Nullable::String,
    'id'        => Integer,
    'name'      => String,
    'progress'  => Fog::Nullable::Integer,
    'serverId'  => Fog::Nullable::Integer,
    'status'    => String,
    'updated'   => String
  }

  tests('success') do

    @server = Fog::Compute[:rackspace].servers.create(:flavor_id => 1, :image_id => 19)
    @server.wait_for { ready? }
    @image_id = nil

    tests("#create_image(#{@server.id})").formats(@image_format) do
      data = Fog::Compute[:rackspace].create_image(@server.id).body['image']
      @image_id = data['id']
      data
    end

    unless Fog.mocking?
      Fog::Compute[:rackspace].images.get(@image_id).wait_for { ready? }
    end

    tests("#get_image_details(#{@image_id})").formats(@image_format) do
      pending if Fog.mocking?
      Fog::Compute[:rackspace].get_image_details(@image_id).body['image']
    end

    tests('#list_images').formats({'images' => [Rackspace::Compute::Formats::SUMMARY]}) do
      Fog::Compute[:rackspace].list_images.body
    end

    tests('#list_images_detail').formats({'images' => [@image_format]}) do
      Fog::Compute[:rackspace].list_images_detail.body
    end

    unless Fog.mocking?
      Fog::Compute[:rackspace].images.get(@image_id).wait_for { ready? }
    end

    tests("#delete_image(#{@image_id})").succeeds do
      pending if Fog.mocking? # because it will fail without the wait just above here, which won't work
      Fog::Compute[:rackspace].delete_image(@image_id)
    end

    @server.destroy

  end

  tests('failure') do

    tests('#delete_image(0)').raises(Excon::Errors::BadRequest) do
      Fog::Compute[:rackspace].delete_image(0)
    end

    tests('#get_image_details(0)').raises(Fog::Compute::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:rackspace].get_image_details(0)
    end

  end

end
