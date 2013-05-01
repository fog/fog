Shindo.tests('Fog::Compute[:xenserver] | VLAN model', ['xenserver']) do

  service = Fog::Compute[:xenserver]
  vlans = service.vlans
  vlan = vlans.first

  tests('The VLAN model should') do
    tests('have the action') do
      %w{ reload destroy save untagged_pif tagged_pif }.each do |action|
        test(action) { vlan.respond_to? action }
      end
    end
    tests('have attributes') do
      model_attribute_hash = vlan.attributes
      attributes = [ 
        :reference,
        :uuid,
        :__untagged_pif,
        :__tagged_pif,
        :tag
      ]
      tests("The VLAN model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { vlan.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::VLAN') { vlan.kind_of? Fog::Compute::XenServer::VLAN}

  end

  tests("#save") do
    test 'should create a VLAN' do
      @net = service.networks.create :name => 'test-net'
      # try to use a bonded interface first
      pif = service.pifs.find { |p| p.device == 'bond0' and p.vlan == "-1" }
      unless pif
        pif = compute.pifs.find { |p| p.device == 'eth0' and p.vlan == "-1" }
      end
      @vlan = vlans.create :tag => 1499,
                           :pif => pif,
                           :network => @net
      @vlan.is_a? Fog::Compute::XenServer::VLAN
    end
    test 'VLAN ID should be 1449' do
      @vlan.tag == 1499
    end
  end

  tests("#destroy") do
    test 'should destroy the network' do
      @vlan.destroy
      @net.destroy
      (vlans.reload.find { |v| v.reference == @vlan.reference }).nil?
    end
  end
  
  tests("#tagged_pif") do
    test 'should return a PIF' do
      vlans.find.first.tagged_pif.is_a? Fog::Compute::XenServer::PIF
    end
  end

  tests("#untagged_pif") do
    test 'should return a PIF' do
      vlans.find.first.untagged_pif.is_a? Fog::Compute::XenServer::PIF
    end
  end

end
