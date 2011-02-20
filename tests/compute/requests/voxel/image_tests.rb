Shindo.tests('Voxel::Compute | image requests', ['voxel']) do

  @image_format = {
    :id        => Integer,
    :name      => String
  }

  tests('success') do
    tests('#images_list').formats([ @image_format ]) do
      Voxel[:compute].images_list
    end

    tests('#images_list(1)').formats([ @image_format ]) do
      Voxel[:compute].images_list(1)
    end
  end

  tests('failure') do
    tests('#images_list(0)').raises(Fog::Voxel::Compute::NotFound) do
      Voxel[:compute].images_list(0)
    end
  end

end
