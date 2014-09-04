Shindo.tests("Fog::Compute[:tutum] | container_create request", 'tutum') do

  compute = Fog::Compute[:tutum]
  name_base = Time.now.to_i

  tests("Create Container") do
    response = compute.container_create("tutum/hello-world",
                                        { :name => "my-awesome-app",
                                          :container_size => "XS",
                                          :web_public_dns => "awesome-app.example.com" })
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
