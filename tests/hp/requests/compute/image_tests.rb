Shindo.tests("Fog::Compute[:hp] | image requests", ['hp']) do

  @image_format = {
    'id'        => String,
    'links'     => [Hash],
    'metadata'  => Fog::Nullable::Hash,
    'server'    => Fog::Nullable::Hash,
    'name'      => String,
    'progress'  => Fog::Nullable::Integer,
    'status'    => String,
    'created'   => Fog::Nullable::String,
    'updated'   => Fog::Nullable::String
  }

  @list_images_format = {
    'id'        => String,
    'links'     => Fog::Nullable::Array,
    'name'      => String
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  tests('success') do
    @server_name = "fogservertest"
    @image_name  = "fogimagetest"
    @server = Fog::Compute[:hp].servers.create(:name => @server_name, :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }
    @image_id = nil

    tests("#create_image(#{@server.id}, #{@image_name})").formats({}) do
      response = Fog::Compute[:hp].create_image(@server.id, @image_name)
      # no data is returned for the call, so get id off the header
      @image_id = response.headers["Location"].split("/")[5]
      {}
    end

    unless Fog.mocking?
      Fog::Compute[:hp].images.get(@image_id).wait_for { ready? }
    end

    tests("#get_image_details(#{@image_id})").formats(@image_format) do
      pending if Fog.mocking?
      Fog::Compute[:hp].get_image_details(@image_id).body['image']
    end

    tests('#list_images').formats({'images' => [@list_images_format]}) do
      Fog::Compute[:hp].list_images.body
    end

    tests('#list_images_detail').formats({'images' => [@image_format]}) do
      Fog::Compute[:hp].list_images_detail.body
    end

    unless Fog.mocking?
      Fog::Compute[:hp].images.get(@image_id).wait_for { ready? }
    end

    tests("#delete_image(#{@image_id})").succeeds do
      pending if Fog.mocking?
      Fog::Compute[:hp].delete_image(@image_id)
    end

    @server.destroy

  end

  tests('failure') do

    tests('#delete_image(0)').raises(Excon::Errors::InternalServerError) do
      Fog::Compute[:hp].delete_image(0)
    end

    tests('#get_image_details(0)').raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].get_image_details(0)
    end

  end

end
