Shindo.tests('Fog::Compute[:clodo] | image requests', ['clodo']) do

###  Fog.mock!

  clodo = Fog::Compute[:clodo]

  @image_format = {
    'id' => String,
    'name' => String,
    'status' => String,
    'vps_type' => String
  }

  @image_details_format = {
    'os_type' => String,
    'os_bits' => String,
    'os_hvm' => String,
    '_attr' => @image_format
  }

  tests("success") do
    tests("- list_images").formats([@image_format]) do
      clodo.list_images.body['images']
    end

    tests("- list_images_detail").formats([@image_details_format]) do
      clodo.list_images_detail.body['images']
    end
  end

  tests("failure") do
    tests("- get_image_details(541)").returns(nil) do
      clodo.images.get(541)
    end
  end
end
