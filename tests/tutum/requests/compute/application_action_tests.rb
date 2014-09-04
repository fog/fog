Shindo.tests("Fog::Compute[:tutum] | application_action request", 'tutum') do

  compute = Fog::Compute[:tutum]
  name = "fog-#{Time.now.to_i}"
  response = compute.application_create( "tutum/hello-world",
                                         {:name => "my-awesome-app",
                                          :container_size => "XS",
                                          :target_num_containers => 2,
                                          :web_public_dns => "awesome-app.example.com"})
  uuid = response['uuid']

  tests("Start Application") do
    response = compute.application_action(uuid, 'start')
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end

  tests("Stop Application") do
    response = compute.application_action(uuid, 'stop')
    test("should be a kind of Hash") { response.kind_of? Hash}
  end

  tests("Redeploy Application") do
    response = compute.application_action(uuid,'stop',{:tag => "v2"} )
    test("should be a kind of Hash") { response.kind_of? Hash}
  end
end
