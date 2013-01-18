Shindo.tests('Fog::Compute[:libvirt] | interface model', ['libvirt']) do

  interfaces = Fog::Compute[:libvirt].interfaces
  interface = interfaces.last

  tests('The interface model should') do
    tests('have the action') do
      test('reload') { interface.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = interface.attributes
      attributes = [ :name, :mac, :active]
      tests("The interface model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { interface.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Libvirt::Interface') { interface.kind_of? Fog::Compute::Libvirt::Interface }
  end

end
