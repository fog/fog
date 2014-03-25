
Shindo.tests('Fog::Compute[:xenserver] | console model', ['xenserver']) do
  consoles = Fog::Compute[:xenserver].consoles
  console = consoles.first

  tests('The console model should') do
    tests('have attributes') do
      model_attribute_hash = console.attributes
      attributes = [
        :reference,
        :location,
        :protocol,
        :uuid,
        :__vm
      ]
      tests("The console model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { console.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::Console') { console.kind_of? Fog::Compute::XenServer::Console }
  end
  tests('A real console should') do
    tests('return valid vm') do
      test('object') { console.vm.kind_of? Fog::Compute::XenServer::Server }
    end
  end
end
