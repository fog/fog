Shindo.tests('Fog::Compute[:xenserver] | console collection', ['xenserver']) do
  conn = Fog::Compute[:xenserver]

  tests('The console collection') do
    consoles = conn.consoles.all

    test('should not be empty') { !consoles.empty? }

    test('should be a kind of Fog::Compute::XenServer::Consoles') { consoles.kind_of? Fog::Compute::XenServer::Consoles }

    tests('should be able to reload itself').succeeds { consoles.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        consoles.get(hosts.first.reference).is_a? Fog::Compute::XenServer::Console
      }
    end
  end
end
