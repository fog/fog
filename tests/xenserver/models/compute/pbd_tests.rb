Shindo.tests('Fog::Compute[:xenserver] | PBD model', ['xenserver']) do

  pbds = Fog::Compute[:xenserver].pbds
  pbd = pbds.first

  tests('The PBD model should') do
    tests('have the action') do
      test('reload') { pbd.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = pbd.attributes
      attributes = [ 
        :reference,
        :uuid,
        :__host,
        :__sr
      ]
      tests("The PBD model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { pbd.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::PBD') { pbd.kind_of? Fog::Compute::XenServer::PBD}

  end

  tests("A real PBD should") do
    tests("return valid host") do
      test("should be a Fog::Compute::XenServer::Host") { pbd.host.kind_of? Fog::Compute::XenServer::Host }
    end
    tests("return valid storage repository") do
      test("should be a Fog::Compute::XenServer::StorageRepository") { pbd.storage_repository.kind_of? Fog::Compute::XenServer::StorageRepository }
    end

  end

end
