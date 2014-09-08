Shindo.tests('Fog::Compute[:tutum] | servers collection', ['tutum']) do

  servers = Fog::Compute[:tutum].servers
  server = create_test_container
  tests('The servers collection') do
    test('should not be empty') { not servers.empty? }
    test('should be a kind of Fog::Compute::Tutum::Servers') { servers.kind_of? Fog::Compute::Tutum::Servers }
    tests('should be able to reload itself') { servers.reload }
    tests('should be able to get a model') do
      tests('by instance uuid') { servers.get(servers.first.uuid) }
    end
  end

  tests("Servers methods") do
    %w{ all each get}.each do |m|
      test("it should respond to #{m}") { servers.respond_to? m }
    end

    test('calling all returns an array') { servers.all.kind_of?(Array) }
    test('calling all returns data') { servers.all.size > 0 }
 
    test('calling get returns a tutum server') { servers.get(server.uuid).kind_of?(Fog::Compute::Tutum::Server) }
    test('calling get returns data') { servers.get(server.uuid) != nil }

    count = 0
    test('calling each does not error') { servers.each {|i| count = count + 1 }; true}
    test('calling each iterates over all') { count == servers.all.size } 
  end
end
