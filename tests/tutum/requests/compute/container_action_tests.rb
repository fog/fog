Shindo.tests("Fog::Compute[:tutum] | container_action request", 'tutum') do

  compute = Fog::Compute[:tutum]
  name = "fog-#{Time.now.to_i}"
  response = compute.container_create( :image => "tutum/hello-world",
                                       :name => "my-awesome-app",
                                       :container_size => "XS",
                                       :web_public_dns => "awesome-app.example.com")
  uuid = response['uuid']

  tests("Start Container") do
    response = compute.container_action(:uuid => uuid, :action => 'start' )
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end

  tests("Stop Container") do
    response = compute.container_action(:uuid => uuid, :action => 'stop' )
    test("should be a kind of Hash") { response.kind_of? Hash}
  end

  tests("Redeploy Container") do
    response = compute.container_action(:uuid => uuid, :action => 'stop', :tag => "v2" )
    test("should be a kind of Hash") { response.kind_of? Hash}
  end
end
