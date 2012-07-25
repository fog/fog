Shindo.tests('Fog::Compute[:xenserver] | PIF model', ['xenserver']) do

  pifs = Fog::Compute[:xenserver].pifs
  pif = pifs.first

  tests('The PIF model should') do
    tests('have the action') do
      test('reload') { pif.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = pif.attributes
      attributes = [ 
        :reference,
        :uuid,
        :physical,
        :mac,
        :currently_attached,
        :device,
        :metrics,
        :dns,
        :gateway,
        :ip,
        :ip_configuration_mode,
        :mtu,
        :__network,
        :netmask,
        :management,
        :vlan,
        :other_config,
        :__host
      ]
      tests("The PIF model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { pif.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::PIF') { pif.kind_of? Fog::Compute::XenServer::PIF}

  end

  tests("A real PIF should") do
    tests("return a valid network") do
      test("should be a Fog::Compute::XenServer::Network") { pif.network.kind_of? Fog::Compute::XenServer::Network }
    end
    tests("return valid host") do
      test("should be a Fog::Compute::XenServer::Host") { pif.host.kind_of? Fog::Compute::XenServer::Host }
    end

  end

end
