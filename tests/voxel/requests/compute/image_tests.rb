Shindo.tests('Fog::Compute[:voxel] | image requests', ['voxel']) do

  @images_format = {
    'images' => [{
      'id'      => Integer,
      'summary' => String
    }],
    'stat' => String
  }

  @image_format = {
    'images' => [{
      'description'       => String,
      'id'                => Integer,
      'filesystem'        => {
        'size'  => Integer,
        'type'  => String,
        'units' => String,
      },
      'operating_system'  => {
        'admin_username'  => String,
        'architecture'    => Integer,
        'family'          => String,
        'product_family'  => String,
        'product_version' => String,
        'version'         => String
      },
      'summary'           => String
    }],
    'stat' => String
  }

  tests('success') do
    tests('#images_list').formats(@images_format) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].images_list.body
    end

    tests('#images_list(1)').formats(@image_format) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].images_list(1).body
    end
  end

  tests('failure') do
    tests('#images_list(0)').raises(Fog::Compute::Voxel::Error) do
      pending if Fog.mocking?
      Fog::Compute[:voxel].images_list(0).body
    end
  end

end
