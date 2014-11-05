Shindo.tests("Fog::Compute[:azure] | images request", ["azure", "compute"]) do

  tests("#list_images") do
    pending if Fog.mocking?
    images = Fog::Compute[:azure].images

    test "returns a Array" do
      images.is_a? Array
    end

    test("should return valid image name") do
      images.first.name.is_a? String
    end

    test("should return records") do
      images.size >= 1
    end
  end

end
