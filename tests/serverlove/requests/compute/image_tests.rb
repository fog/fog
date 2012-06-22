Shindo.tests('Fog::Compute[:serverlove] | drive requests', ['serverlove']) do

  @image_format = {
    'drive'                => String,
    'name'              => String,
    'user'              => String,
    'size'              => Integer,
    'claimed'           => Fog::Nullable::String,
    'status'            => String,
    'encryption:cipher' => String,
    'read:bytes'        => String,
    'write:bytes'       => String,
    'read:requests'     => String,
    'write:requests'    => String
  }
  
  tests('success') do

    attributes = { name: 'Test', size: 12345 }

    tests("#create_image").formats(@image_format) do
      @image = Fog::Compute[:serverlove].create_image(attributes).body
    end
    
    tests("#list_images").succeeds do
      Fog::Compute[:serverlove].images
    end
    
    tests("#update_image").returns(true) do
      @image['name'] = "Diff"
      Fog::Compute[:serverlove].update_image(@image['drive'], { name: @image['name'], size: @image['size']})
      Fog::Compute[:serverlove].images.get(@image['drive']).name == "Diff"
    end
    
    tests("#destroy_image").succeeds do
      Fog::Compute[:serverlove].destroy_image(@image['drive'])
    end

  end

end
