Shindo.tests("Fog::Compute[:tutum] | application_create request", 'tutum') do
  compute = Fog::Compute[:tutum]
  name_base = Time.now.to_i

  tests("Create Application") do
    name = fog_application_name
    response = compute.application_create( "tutum/hello-world",
                                           {:name => name,
                                            :container_size => "XS",
                                            :target_num_containers => 2,
                                            :web_public_dns => "#{name}.example.com"})
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
