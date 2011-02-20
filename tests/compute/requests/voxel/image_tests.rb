Shindo.tests('Voxel::Compute | image requests', ['voxel']) do

  @image_format = {
    'id'        => Integer,
    'name'      => String
  }

  tests('success') do
    tests('#images_list').formats([ { :id => Integer, :name => String } ]) do
      Voxel[:compute].images_list
    end

    tests('#images_list(1)').formats([ { :id => Integer, :name => String } ]) do
      Voxel[:compute].images_list(1)
    end
  end

  tests('failure') do
    tests('#images_list(0)').raises(Fog::Voxel::Compute::NotFound) do
      #pending if Fog.mocking?
      Voxel[:compute].images_list(0)
    end
  end

end
