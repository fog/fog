Shindo.tests("Fog::Compute[:tutum] | image_update request", 'tutum') do

  compute = Fog::Compute[:tutum]

  tests("Update image") do
    response = compute.image_update({ :name => "quay.io/user/my-private-image",
                                      :username => "user+read",
                                      :password => "SHJW0SAOQ2BFBZVEVQH98SOL6V7UPQ0PH2VNKRVMMXR6T8Q43AHR88242FRPPTPG" })
    test("should be a kind of Hash") { response.kind_of?  Hash}
    test("should have a name") { !response['name'].nil? && !response['name'].empty? }
  end

  tests("Fail Updating image") do
    begin
      response = compute.image_update({})
      raise "Should have failed"
    rescue => e
      test("error should be a kind of ArgumentError") { e.kind_of? ArgumentError}
    end
  end

end
