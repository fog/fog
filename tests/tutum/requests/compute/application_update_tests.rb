Shindo.tests("Fog::Compute[:tutum] | application_update request", 'tutum') do

  compute = Fog::Compute[:tutum]
  name_base = Time.now.to_i
  uuid = nil

  tests("update Container") do
    response = compute.application_create( "tutum/hello-world", 
                                           { :name => "my-awesome-app",
                                             :container_size => "XS",
                                             :target_num_containers => 2,
                                             :web_public_dns => "awesome-app.example.com"} )
    uuid = response['uuid']
  end

  tests("Update Application") do
    response = compute.application_update(uuid, {:target_num_containers => 3} )
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
