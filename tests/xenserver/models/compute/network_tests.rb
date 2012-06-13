Shindo.tests('Fog::Compute[:network] | network model', ['xenserver']) do

  require 'pp'
  networks = Fog::Compute[:xenserver].networks
  network = networks.first

  tests('The network model should') do
    tests('have the action') do
      test('reload') { network.respond_to? 'reload' }
      #%w{ refresh stop clean_shutdown hard_shutdown start destroy reboot hard_reboot clean_reboot }.each do |action|
      #  test(action) { server.respond_to? action }
      #  #test("#{action} returns successfully") { server.send(action.to_sym) ? true : false }
      #end
    end
    tests('have attributes') do
      model_attribute_hash = network.attributes
      attributes = [ 
        :reference,
        :uuid,
        :__vifs,
        :tags,
        :mtu,
        :bridge,
        :name,
        :other_config,
        :__pifs,
        :allowed_operations,
        :current_operations,
        :blobs
      ]
      tests("The network model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { network.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::Network') { network.kind_of? Fog::Compute::XenServer::Network }

  end

  tests("A real network should") do
    tests("return valid vifs") do
      test("as an array") { network.vifs.kind_of? Array }
      network.vifs.each { |i| 
          test("and each VIF should be a Fog::Compute::XenServer::VIF") { i.kind_of? Fog::Compute::XenServer::VIF }
      } 
    end
    tests("return valid PIFs") do 
      networks.each do |network|
          test("as an array") { network.pifs.kind_of? Array }
          network.pifs.each { |i| 
              test("and each PIF should be a Fog::Compute::XenServer::PIF") { i.kind_of? Fog::Compute::XenServer::PIF}
          } 
      end
    end

    test("be able to refresh itself") { network.refresh }

  end

end
