Shindo.tests('Fog::Compute[:xenserver] | HostCpu model', ['xenserver']) do

  host = Fog::Compute[:xenserver].hosts.first
  host_cpu = host.host_cpus.first

  tests('The HostCpu model should') do
    tests('have attributes') do
      model_attribute_hash = host_cpu.attributes
      attributes = [ 
        :reference,
        :uuid,
        :family,
        :flags,
        :__host,
        :model_name,
        :model,
        :number,
        :other_config,
        :speed,
        :stepping,
        :utilisation,
        :vendor
      ]
      tests("The HostCpu model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { host_cpu.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::HostCpu') do
      host_cpu.kind_of? Fog::Compute::XenServer::HostCpu
    end

    test("return a valid host") do
      host_cpu.host.kind_of? Fog::Compute::XenServer::Host
    end
    
    test("have a valid vendor string") do
      host_cpu.vendor.kind_of? String
    end
    
    test("have a valid other_config") do
      host_cpu.other_config.kind_of? Hash
    end
    
    test("have a valid utilisation attribute") do
      host_cpu.utilisation.kind_of? Float
    end

  end

end
