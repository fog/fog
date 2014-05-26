Shindo.tests('Fog::Compute[:xenserver] | set_attribute request', ['xenserver']) do

  # Setup cleanup
  destroy_ephemeral_servers

  connection = Fog::Compute[:xenserver]
  servers = connection.servers
  server = create_ephemeral_server

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
    test('set the multiple valued attribute memory_limits }') do
      server = create_ephemeral_server
      server.stop 'hard'
      server.wait_for { not running? }
      response = connection.set_attribute('VM',
                                          server.reference,
                                          'memory_limits',
                                          '1073741824',
                                          '1073741824',
                                          '1073741824',
                                          '1073741824'
                                         )
      server.reload
      (server.memory_dynamic_max == "1073741824") and \
        (server.memory_dynamic_min == "1073741824") and \
        (server.memory_static_max == "1073741824") and \
        (server.memory_static_min == "1073741824")

      server.start
    end
    test('set an array valued attribute') do
      server = create_ephemeral_server
      response = connection.set_attribute('VM',
                                          server.reference,
                                          'tags',
                                          ['foo','bar']
                                         )
      server.reload
      server.tags.include?('foo') and server.tags.include?('bar')
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,attr,value missing') { connection.get_record }
  end

  # Teardown cleanup
  destroy_ephemeral_servers

end
