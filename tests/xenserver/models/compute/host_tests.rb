
Shindo.tests('Fog::Compute[:xenserver] | host model', ['xenserver']) do

  hosts = Fog::Compute[:xenserver].hosts
  host = hosts.first 

  tests('The host model should') do
    tests('have the action') do
      test('reload') { host.respond_to? 'reload' }
    end

    tests('have attributes') do
      model_attribute_hash = host.attributes
      attributes = [ 
        :reference,
        :uuid,
        :name,
        :address,
        :allowed_operations,
        :enabled,
        :hostname,
        :metrics,
        :name_description,
        :other_config,
        :__pbds,
        :__pifs,
        :__resident_vms
      ]
      tests("The host model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { host.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::Host') { host.kind_of? Fog::Compute::XenServer::Host }

  end

  tests("A real host should") do
    tests("return valid PIFs") do
      test("as an array") { host.pifs.kind_of? Array }
      host.pifs.each { |i| 
          test("and each PIF should be a Fog::Compute::XenServer::PIF") { i.kind_of? Fog::Compute::XenServer::PIF}
      } 
    end
    tests("return valid PBDs") do
      test("as an array") { host.pbds.kind_of? Array }
      host.pbds.each { |i| 
          test("and each PBD should be a Fog::Compute::XenServer::PBD") { i.kind_of? Fog::Compute::XenServer::PBD}
      } 
    end
    tests("return valid resident servers") do
      test("as an array") { host.resident_servers.kind_of? Array }
      host.resident_servers.each { |i| 
          test("and each Server should be a Fog::Compute::XenServer::Server") { i.kind_of? Fog::Compute::XenServer::Server}
      } 
    end

  end


end
