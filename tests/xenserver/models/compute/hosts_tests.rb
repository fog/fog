Shindo.tests('Fog::Compute[:xenserver] | hosts collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]

  tests('The hosts collection') do
    hosts = conn.hosts.all

    test('should not be empty') { !hosts.empty? }

    test('should be a kind of Fog::Compute::XenServer::Hosts') { hosts.kind_of? Fog::Compute::XenServer::Hosts }

    tests('should be able to reload itself').succeeds { hosts.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        hosts.get(hosts.first.reference).is_a? Fog::Compute::XenServer::Host
      }
    end

  end

end
