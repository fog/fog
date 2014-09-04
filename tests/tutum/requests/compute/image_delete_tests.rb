require 'fog'
Shindo.tests("Fog::Compute[:tutum] | image_delete request", 'tutum') do

  compute = Fog::Compute[:tutum]
  image_hash = compute.image_create("quay.io/user/my-private-image",
                                    "user+read",
                                    "SHJW0SAOQ2BFBZVEVQH98SOL6V7UPQ0PH2VNKRVMMXR6T8Q43AHR88242FRPPTPG")
  tests("Delete image") do
    response = compute.image_delete(image_hash['name'])
    test("should be success") { response ? true : false } 
  end
end
