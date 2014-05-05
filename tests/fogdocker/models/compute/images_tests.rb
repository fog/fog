Shindo.tests('Fog::Compute[:fogdocker] | images collection', ['fogdocker']) do

  images = Fog::Compute[:fogdocker].images

  tests('The images collection') do
    test('should be a kind of Fog::Compute::Fogdocker::images') { images.kind_of? Fog::Compute::Fogdocker::Images }
  end

end
