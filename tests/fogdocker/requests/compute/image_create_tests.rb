Shindo.tests("Fog::Compute[:fogdocker] | image_create request", 'fogdocker') do

  compute = Fog::Compute[:fogdocker]

  tests("Create image") do
    response = compute.image_create({'fromImage' => 'mattdm/fedora', 'repo'=>'test', 'tag'=>'create_image'})
    test("should be a kind of Hash") { response.kind_of?  Hash}
    test("should have an id") { !response['id'].nil? && !response['id'].empty? }
  end

  tests("Fail Creating image") do
    begin
      response = compute.image_create('fromImage' => 'not/exists')
      test("should be a kind of Hash") { response.kind_of?  Hash} #mock never raise exceptions
    rescue => e
      #should raise missing command in the create attributes.
      test("error should be a kind of Docker::Error") { e.kind_of?  Docker::Error::ServerError}
    end
  end

end
