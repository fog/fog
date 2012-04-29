Shindo.tests('Fog::Compute[:serverlove] | drive requests', ['serverlove']) do

  @image_format = {
    'id'                => String,
    'name'              => String,
    'user'              => String,
    'size'              => Integer,
    'claimed'           => Fog::Nullable::String
    'status'            => String,
    'encryption_cipher' => String
  }

  tests('success') do

    attributes = { name: 'Test', size: 12345 }

    tests("#create_image").formats(@image_format) do
      @image = Fog::Compute[:serverlove].create(attributes)
      @image
    end
    
    tests('#list_images_detail').formats({'images' => [@image_format]}) do
      Fog::Compute[:serverlove].images
    end

    @image.destroy

  end

end
