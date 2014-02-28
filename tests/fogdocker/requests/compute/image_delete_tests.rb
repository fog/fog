Shindo.tests("Fog::Compute[:fogdocker] | image_delete request", 'fogdocker') do

  compute = Fog::Compute[:fogdocker]
  image_hash = compute.image_create({'fromImage' => 'mattdm/fedora', 'repo'=>'test', 'tag'=>'delete_image'})

  tests("Delete image") do
    begin
      response = compute.image_delete(:id => image_hash['id'])
      test("should be success") { response ? true : false } #mock doesn't throw errors
    rescue => e
      #should raise image not found
      test("error should be a kind of Docker::Error::NotFoundError") { e.kind_of?  Docker::Error::NotFoundError}
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when id option is missing') { compute.container_delete }
  end

end
