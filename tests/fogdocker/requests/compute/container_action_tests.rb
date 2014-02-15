Shindo.tests("Fog::Compute[:fogdocker] | container_action request", 'fogdocker') do

  compute = Fog::Compute[:fogdocker]
  name = "fog-#{Time.now.to_i}"
  response = compute.container_create(:name => name, 'image' => 'mattdm/fedora:f19','Cmd' => ['date'] )
  id = response['id']


  tests("Run Container") do
    response = compute.container_action(:id => id, :action => 'run' )
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end

  tests("Stop Container") do
    response = compute.container_action(:id => id, :action => 'stop' )
    test("should be a kind of Hash") { response.kind_of? Hash}
    test("should be stopped") { response['State']['Running'] == false}
  end

  tests("Kill Container") do
    response = compute.container_action(:id => id, :action => 'kill' )
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end

end
