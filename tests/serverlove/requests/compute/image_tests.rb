Shindo.tests('Fog::Compute[:serverlove] | drive requests', ['serverlove']) do

  @image_format = {
    'drive'             => String,
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

    attributes = { 'name' => 'Test', 'size' => '24234567890' }

    tests("#create_image").formats(@image_format) do
      @image = Fog::Compute[:serverlove].create_image(attributes).body
    end

    tests("#list_images").succeeds do
      Fog::Compute[:serverlove].images
    end

    tests("#update_image").returns(true) do
      @image['name'] = "Diff"
      Fog::Compute[:serverlove].update_image(@image['drive'], { :name => @image['name'], :size => @image['size']})
      Fog::Compute[:serverlove].images.get(@image['drive']).name == "Diff"
    end

    tests("#load_standard_image").returns(true) do
      # Load centos
      Fog::Compute[:serverlove].load_standard_image(@image['drive'], '88ed067f-d2b8-42ce-a25f-5297818a3b6f')
      Fog::Compute[:serverlove].images.get(@image['drive']).imaging != "" # This will be "x%" when imaging
    end

    tests("waits for imaging...").returns(true) do
      while(percent_complete = Fog::Compute[:serverlove].images.get(@image['drive']).imaging)
        sleep(1)
        STDERR.print "#{percent_complete} "
        break if percent_complete.include?("100")
      end
      STDERR.print "100% "
      true
    end

    tests("#destroy_image").succeeds do
      Fog::Compute[:serverlove].destroy_image(@image['drive'])
    end

  end

end
