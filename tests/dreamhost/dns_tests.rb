Shindo.tests('Fog::DNS[:dreamhost]', ['dreamhost', 'dns']) do

  service = Fog::DNS[:dreamhost]

  tests("collections") do
    %w{ records zones }.each do |collection|
      test("it should respond to #{collection}") { service.respond_to? collection }
      test("it should respond to #{collection}.all") { eval("service.#{collection}").respond_to? 'all' }
      test("it should respond to #{collection}.get") { eval("service.#{collection}").respond_to? 'get' }
    end
  end

  tests("requests") do
    %w{ list_records create_record delete_record }.each do |request|
      test("it should respond to #{request}") { service.respond_to? request }
    end
  end

end
