Shindo.tests('Fog::Compute[:tutum] | applications collection', ['tutum']) do

  applications = Fog::Compute[:tutum].applications
  tests('The applications collection') do
    test('should not be empty') { not applications.empty? }
    test('should be a kind of Fog::Compute::Tutum:Applications') { applications.kind_of? Fog::Compute::Tutum::Applications }
    tests('should be able to reload itself') { applications.reload }
    tests('should be able to get a model') do
      tests('by instance uuid') { applications.get(applications.first.uuid) }
    end
  end

  tests("Applications methods") do
    %w{ all each get}.each do |m|
      test("it should respond to #{m}") { applications.respond_to? m }
    end

    test('calling all returns an array') { applications.all.kind_of?(Array) }
    test('calling all returns data') { applications.all.size > 0 }
 
    test('calling get returns a tutum application') { applications.get("foobar").kind_of?(Fog::Compute::Tutum::Application) }
    test('calling get returns data') { applications.get("foobar") != nil }

    count = 0
    test('calling each does not error') { applications.each {|i| count = count + 1 }; true}
    test('calling each iterates over all') { count == applications.all.size } 
  end
end
