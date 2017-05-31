Shindo.tests("Fog::Compute[:tutum] | image_create request", 'tutum') do

  compute = Fog::Compute[:tutum]

  if Fog.mocking?
    tests("Create image") do
      response = compute.image_create("quay.io/user/my-private-image",
                                       "user+read",
                                       "SHJW0SAOQ2BFBZVEVQH98SOL6V7UPQ0PH2VNKRVMMXR6T8Q43AHR88242FRPPTPG")
      test("should be a kind of Hash") { response.kind_of?  Hash}
      test("should have a name") { !response['name'].nil? && !response['name'].empty? }
    end

    tests("Fail Creating image") do
      begin
        response = compute.image_create(:name => 'foobar')
        raise "Should have failed"
      rescue => e
        test("error should be a kind of ArgumentError") { e.kind_of? ArgumentError}
      end
    end
  end
end
