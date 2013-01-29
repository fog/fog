Shindo.tests('Fog::Compute[:digitalocean] | list_images request', ['digitalocean', 'compute']) do

  # {"id"=>1601, "name"=>"CentOS 5.8 x64", "distribution"=>"CentOS"}
  @image_format = {
    'id'           => Integer,
    'name'         => String,
    'distribution' => String
  }

  tests('success') do

    tests('#list_images') do
      images = Fog::Compute[:digitalocean].list_images.body
      test 'returns a Hash' do
        images.is_a? Hash
      end
      tests('image').formats(@image_format, false) do
        images['images'].first
      end
    end

  end

end
