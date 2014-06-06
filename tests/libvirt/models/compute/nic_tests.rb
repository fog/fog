Shindo.tests('Fog::Compute[:libvirt] | nic model', ['libvirt']) do

  nic = Fog::Compute[:libvirt].servers.all.select{|v| v.name =~ /^fog/}.first.nics.first

  tests('The nic model should') do
    tests('have the action') do
      test('reload') { nic.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = nic.attributes
      attributes = [ :mac,
        :model,
        :type,
        :network,
        :bridge]
      tests("The nic model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { nic.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.delete(:bridge)
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Libvirt::Nic') { nic.kind_of? Fog::Compute::Libvirt::Nic }
  end

end
