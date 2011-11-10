Shindo.tests('Fog::Compute[:brightbox] | image requests', ['brightbox']) do

  tests('success') do

    ## Difficult to test without having uploaded an Image to your account to register
    # creation_options = {
    #   "arch" => "i686",
    #   "source" => "fnord"
    # }
    # tests("#create_image(#{creation_options.inspect})").formats(Brightbox::Compute::Formats::Full::IMAGE) do
    #   data = Fog::Compute[:brightbox].create_image(creation_options)
    #   @image_id = data["id"]
    #   data
    # end

    # Fog::Compute[:brightbox].images.get(@image_id).wait_for { ready? }

    tests("#list_images").formats(Brightbox::Compute::Formats::Collection::IMAGES) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].list_images
      @image_id = data.first["id"]
      data
    end

    tests("#get_image('#{@image_id}')").formats(Brightbox::Compute::Formats::Full::IMAGE) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_image(@image_id)
    end

    ## Until Image creation can be automated, we shouldn't be updating Images randomly
    # update_options = {}
    # tests("#update_image('#{@image_id}', #{update_options.inspect})").formats(Brightbox::Compute::Formats::Full::IMAGE) do
    #   Fog::Compute[:brightbox].update_image(@image_id, :name => "New name from Fog test")
    # end

    ## Same as other tests - can't be deleting them unless part of the test run
    # tests("#destroy_server('#{@image_id}')").formats(Brightbox::Compute::Formats::Full::IMAGE) do
    #   Fog::Compute[:brightbox].destroy_image(@image_id)
    # end

  end

  tests('failure') do

    tests("#get_image('img-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_image('img-00000')
    end

    tests("#get_image").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_image
    end

  end

end
