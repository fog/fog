Shindo.tests('Fog::Compute[:xenserver] | HostMetrics model', ['xenserver']) do

  host = Fog::Compute[:xenserver].hosts.first

  tests('The HostMetrics model should') do
    tests('have attributes') do
      model_attribute_hash = host.metrics.attributes
      attributes = [ 
        :reference,
        :uuid,
        :memory_free,
        :memory_total,
        :other_config,
        :last_updated
      ]
      tests("The HostMetrics model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { host.metrics.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::HostMetrics') do
      host.metrics.kind_of? Fog::Compute::XenServer::HostMetrics
    end

    test("have a last_updated Time property") { host.metrics.last_updated.kind_of? Time }
    
    test("return a valid memory_free ammount") do 
      (host.metrics.memory_free =~ /^\d+$/) == 0 
    end

    test("have memory_free > 0") { host.metrics.memory_free.to_i > 0 }
    
    test("return a valid memory_total ammount") do
      (host.metrics.memory_total =~ /^\d+$/) == 0 
    end
    
    test("have memory_total > 0") { host.metrics.memory_total.to_i > 0 }

  end

end
