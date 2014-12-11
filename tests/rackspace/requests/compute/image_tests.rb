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

  @service = Fog::Compute.new(:provider => :rackspace, :version => :v1)

  tests('success') do

    @server =  @service.servers.create(:flavor_id => 1, :image_id => 19)
    @server.wait_for { ready? }
    @image_id = nil

    tests("#create_image(#{@server.id})").formats(@image_format) do
      data =  @service.create_image(@server.id).body['image']
      @image_id = data['id']
      data
    end

    unless Fog.mocking?
       @service.images.get(@image_id).wait_for { ready? }
    end

    tests("#get_image_details(#{@image_id})").formats(@image_format) do
      pending if Fog.mocking?
       @service.get_image_details(@image_id).body['image']
    end

    tests('#list_images').formats({'images' => [Rackspace::Compute::Formats::SUMMARY]}) do
       @service.list_images.body
    end

    tests('#list_images_detail').formats({'images' => [@image_format]}) do
       @service.list_images_detail.body
    end

    unless Fog.mocking?
       @service.images.get(@image_id).wait_for { ready? }
    end

    tests("#delete_image(#{@image_id})").succeeds do
      pending if Fog.mocking? # because it will fail without the wait just above here, which won't work
       @service.delete_image(@image_id)
    end

    @server.destroy

  end

  tests('failure') do

    tests('#delete_image(0)').raises(Fog::Compute::Rackspace::NotFound) do
       @service.delete_image(Fog::Rackspace::MockData::NOT_FOUND_ID)
    end

    tests('#get_image_details(0)').raises(Fog::Compute::Rackspace::NotFound) do
      pending if Fog.mocking?
       @service.get_image_details(Fog::Rackspace::MockData::NOT_FOUND_ID)
    end

  end

end
