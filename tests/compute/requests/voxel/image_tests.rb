Shindo.tests('Voxel::Compute | image requests', ['voxel']) do

  @images_format = [{
    'id'    => Integer,
    'summary'  => String
  }]

  @image_format = {
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
  }

  tests('success') do
    tests('#images_list').formats(@images_format) do
      pending if Fog.mocking?
      Voxel[:compute].images_list
    end

    tests('#images_list(1)').formats([@image_format]) do
      pending if Fog.mocking?
      Voxel[:compute].images_list(1)
    end
  end

  tests('failure') do
    tests('#images_list(0)').raises(Fog::Voxel::Compute::Error) do
      pending if Fog.mocking?
      Voxel[:compute].images_list(0)
    end
  end

end
