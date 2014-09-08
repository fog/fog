Shindo.tests('Fog::Compute[:tutum] | images collection', ['tutum']) do

  images = Fog::Compute[:tutum].images

  tests('The images collection') do
    test('should not be empty') { not images.empty? }
    test('should be a kind of Fog::Compute::Tutum::Images') { images.kind_of? Fog::Compute::Tutum::Images }
    tests('should be able to reload itself') { images.reload }
    tests('should be able to get a model') do
      tests('by instance uuid') { images.get(images.first.name) }
    end
  end

  tests("Images methods") do
    %w{ all each get}.each do |m|
      test("it should respond to #{m}") { images.respond_to? m }
    end

    test('calling all returns an array') { images.all.kind_of?(Array) }
    
    if Fog.mocking? 
      test('calling all returns data') { images.all.size > 0 }
 
      test('calling get returns a tutum image') { images.get("foobar").kind_of?(Fog::Compute::Tutum::Image) }
      test('calling get returns data') { images.get("foobar") != nil }
    end

    count = 0
    test('calling each does not error') { images.each {|i| count = count + 1 }; true}
    test('calling each iterates over all') { count == images.all.size } 
  end
end
