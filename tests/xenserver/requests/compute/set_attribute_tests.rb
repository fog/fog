Shindo.tests('Fog::Compute[:xenserver] | set_attribute request', ['xenserver']) do

  connection = Fog::Compute[:xenserver]
  servers = connection.servers
  # pre-flight cleanup
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end
  server = Fog::Compute[:xenserver].servers.create(:name => test_ephemeral_vm_name, 
                                                   :template_name => test_template_name)
  tests('Setting an attribute with set_attribute should') do
    test('set the PV_bootloader attr to foobar') do
      response = connection.set_attribute('VM', server.reference, 'PV_bootloader', 'foobar')
      server.reload
      server.pv_bootloader == 'foobar'
    end
    test('set the PV-bootloader attr to stuff') do
      response = connection.set_attribute('VM', server.reference, 'PV-bootloader', 'stuff')
      server.reload
      server.pv_bootloader == 'stuff'
    end
    test('set the other_config attr { "foo" => "bar", :stuff => "crap" }') do
      response = connection.set_attribute('VM', server.reference, 'other_config', { "foo" => "bar", :stuff => 'crap' })
      server.reload
      (server.other_config['foo'] == 'bar') and \
        (server.other_config['stuff'] == 'crap')
    end
  end
  
  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,attr,value missing') { connection.get_record }
  end
end
