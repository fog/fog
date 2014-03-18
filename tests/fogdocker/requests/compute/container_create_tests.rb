Shindo.tests("Fog::Compute[:fogdocker] | container_create request", 'fogdocker') do

  compute = Fog::Compute[:fogdocker]
  name_base = Time.now.to_i

  tests("Create Container") do
    response = compute.container_create(:name => 'fog-'+name_base.to_s, 'image' => 'mattdm/fedora:f19','Cmd' => ['date'] )
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end

  tests("Fail Creating Container") do
    begin
      response = compute.container_create(:name => 'fog-'+name_base.to_s, 'image' => 'mattdm/fedora:f19')
      test("should be a kind of Hash") { response.kind_of?  Hash} #mock never raise exceptions
    rescue => e
      #should raise missing command in the create attributes.
      test("error should be a kind of Docker::Error") { e.kind_of?  Docker::Error::ServerError}
    end
  end

end
