Shindo.tests('Fog::Compute[:xenserver] | VBD model', ['VBD']) do

  vbds = Fog::Compute[:xenserver].vbds
  vbd = vbds.first

  tests('The VBD model should') do
    tests('have the action') do
      test('reload') { vbd.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = vbd.attributes
      attributes = [ 
        :reference,
        :uuid,
        :currently_attached,
        :__vdi,
        :__vm,
        :device,
        :status_detail,
        :type,
        :userdevice
      ]
      tests("The VBD model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { vbd.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::VBD') { vbd.kind_of? Fog::Compute::XenServer::VBD}

  end

  tests("A real VBD should") do
    tests("return a valid VDI") do
      test("should be a Fog::Compute::XenServer::VDI") { vbd.vdi.kind_of? Fog::Compute::XenServer::VDI }
    end
    tests("return valid Server") do
      test("should be a Fog::Compute::XenServer::Server") { vbd.server.kind_of? Fog::Compute::XenServer::Server }
    end

  end

end
