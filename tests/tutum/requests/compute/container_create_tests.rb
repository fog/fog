Shindo.tests("Fog::Compute[:tutum] | container_create request", 'tutum') do

  compute = Fog::Compute[:tutum]
  
  tests("Create Container") do
    response = compute.container_create("tutum/hello-world",
                                        fog_test_container_attributes)
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
