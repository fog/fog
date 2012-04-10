Shindo.tests('Fog::Compute[:xenserver] | VBD model', ['VBD']) do

  vbds = Fog::Compute[:xenserver].vbds
  vbd = vbds.first

  tests('The VBD model should') do
    tests('have the action') do
      test('reload') { vbd.respond_to? 'reload' }
      test('eject') { vbd.respond_to? 'eject' }
      test('insert') { vbd.respond_to? 'insert' }
      test('unplug') { vbd.respond_to? 'unplug' }
      test('unplug_force') { vbd.respond_to? 'unplug_force' }
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
        :allowed_operations,
        :current_operations,
        :status_code,
        :storage_lock,
        :mode,
        :runtime_properties,
        :unpluggable,
        :userdevice,
        :bootable,
        :empty,
        :__metrics
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
    test("have a valid OpaqueRef") do 
      puts vbd.reference
      (vbd.reference =~ /OpaqueRef:/).eql?(0) and \
        vbd.reference != "OpaqueRef:NULL"
    end
    tests("belong to a VM when attached") do
      vbds.each do |vbd|
        test("#{vbd.uuid}") do
          if vbd.currently_attached
            (vbd.__vm =~ /OpaqueRef/).eql?(0) and \
              vbd.__vm != "OpaqueRef:NULL"
          else
            true
          end
        end
      end
    end
    vbds.each do |vbd|
      test("return a Fog::Compute::XenServer::VDI when type Disk") do
        if vbd.type == 'Disk'
          vbd.vdi.kind_of? Fog::Compute::XenServer::VDI
        else
          true
        end
      end
      test("return a nil VDI when type CD") do
        if vbd.type == 'CD'
          vbd.vdi.nil? 
        else
          true
        end
      end
    end
    tests("return a nil when type is CD") do
      vbds.each do |vbd|
      end
    end
    tests("return valid Server") do
      test("should be a Fog::Compute::XenServer::Server") { vbd.server.kind_of? Fog::Compute::XenServer::Server }
    end
    test("return a VbdMetrics object") { vbd.metrics.kind_of? Fog::Compute::XenServer::VbdMetrics }
    test("be able to be unplugged when type is CD") do
       if vbd.type == "CD"
         vbd.unpluggable == true
       else
         vbd.unpluggable == false
       end
    end

  end

  tests("VBD Metrics should") do
    test("have a last_updated Time property") { vbd.metrics.last_updated.kind_of? Time }
  end

end
