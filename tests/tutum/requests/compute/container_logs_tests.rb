Shindo.tests("Fog::Compute[:tutum] | container_logs request", 'tutum') do

  compute = Fog::Compute[:tutum]
  name = "fog-#{Time.now.to_i}"
  response = compute.container_create( :image => "tutum/hello-world",
                                       :name => "my-awesome-app",
                                       :container_size => "XS",
                                       :web_public_dns => "awesome-app.example.com")
  uuid = response['uuid']

  tests("Get Logs") do
    response = compute.container_logs(uuid)
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
