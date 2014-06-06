Shindo.tests('Fog::Compute[:libvirt] | network model', ['libvirt']) do

  networks = Fog::Compute[:libvirt].networks
  network = networks.last

  tests('The network model should') do
    tests('have the action') do
      test('reload') { network.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = network.attributes
      attributes = [ :name, :uuid, :bridge_name]
      tests("The network model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { network.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Libvirt::Network') { network.kind_of? Fog::Compute::Libvirt::Network }
  end

end
