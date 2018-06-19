Shindo.tests('Fog::Compute[:opennebula]', ['opennebula']) do
  begin
    compute = Fog::Compute[:opennebula]
  rescue Fog::Errors::LoadError
    pending
  end

  tests("Compute collections") do
    %w{networks groups}.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end

  tests("Compute requests") do
    %w{list_networks}.each do |request|
      test("it should respond to #{request}") { compute.respond_to? request }
    end
  end
end
