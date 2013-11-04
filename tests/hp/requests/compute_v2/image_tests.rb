Shindo.tests("Fog::Compute::HPV2 | image requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @image_format = {
    'id'        => String,
    'links'     => [Hash],
    'metadata'  => Fog::Nullable::Hash,
    'server'    => Fog::Nullable::Hash,
    'name'      => String,
    'progress'  => Fog::Nullable::Integer,
    'minDisk'   => Fog::Nullable::Integer,
    'minRam'    => Fog::Nullable::Integer,
    'status'    => String,
    'created'   => Fog::Nullable::String,
    'updated'   => Fog::Nullable::String
  }

  @list_images_format = {
    'id'        => String,
    'links'     => Fog::Nullable::Array,
    'name'      => String
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || "7f60b54c-cd15-433f-8bed-00acbcd25a17"

  tests('success') do
    @server_name = 'fogservertest'
    @image_name  = 'fogimagetest'
    @image_id = nil
    @server_id = nil

    # check to see if there are any existing servers, otherwise create one
    if (data = service.list_servers(:status => 'ACTIVE').body['servers'][0])
      @server_id = data['id']
    else
      #@server = service.servers.create(:name => @server_name, :flavor_id => 100, :image_id => @base_image_id)
      #@server.wait_for { ready? }
      data = service.create_server(@server_name, 100, @base_image_id).body['server']
      @server_id = data['id']
    end

    tests("#create_image(#{@server_id}, #{@image_name})").formats({}) do
      response = service.create_image(@server_id, @image_name)
      # no data is returned for the call, so get id off the header
      @image_id = response.headers["Location"].split("/")[5]
      {}
    end

    #unless Fog.mocking?
    #  service.images.get(@image_id).wait_for { ready? }
    #end

    tests("#get_image_details(#{@image_id})").formats(@image_format) do
      service.get_image_details(@image_id).body['image']
    end

    tests('#list_images').formats({'images' => [@list_images_format]}) do
      service.list_images.body
    end

    tests('#list_images_detail').formats({'images' => [@image_format]}) do
      service.list_images_detail.body
    end

    tests("#delete_image(#{@image_id})").succeeds do
      service.delete_image(@image_id)
    end

    service.delete_server(@server_id)

  end

  tests('failure') do

    tests('#delete_image("0")').raises(Fog::Compute::HPV2::NotFound) do
      service.delete_image('0')
    end

    tests('#get_image_details("0")').raises(Fog::Compute::HPV2::NotFound) do
      service.get_image_details('0')
    end

  end

end
