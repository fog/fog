Shindo.tests("Fog::Compute[:tutum] | application_create request", 'tutum') do

  compute = Fog::Compute[:tutum]
  name_base = Time.now.to_i

  tests("Create Application") do
    response = compute.application_create( :image => "tutum/hello-world",
                                           :name => "my-awesome-app",
                                           :container_size => "XS",
                                           :target_num_containers => 2,
                                           :web_public_dns => "awesome-app.example.com")
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end

  tests("Fail Creating Application") do
    begin
      response = compute.application_create( :name => "my-awesome-app" )
      raise "Should have failed"
    rescue => e
      #should raise missing command in the create attributes.
      test("error should be a kind of ArgumentError") { e.kind_of?  ArgumentError}
    end
  end

end
