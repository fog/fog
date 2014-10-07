Shindo.tests('Fog::Compute[:xenserver] | Vlans collection', ['xenserver']) do

  service = Fog::Compute[:xenserver]

  tests('The Vlans collection') do

    test('should not be empty') { !service.vlans.empty? }

    test('should be a kind of Fog::Compute::XenServer::Vlans') do
      service.vlans.kind_of? Fog::Compute::XenServer::Vlans
    end

    tests('should be able to reload itself').succeeds { service.vlans.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        service.vlans.get(service.vlans.first.reference).is_a? \
          Fog::Compute::XenServer::VLAN
      }
    end

  end

  tests('failures') do
    test 'with an invalid reference' do
      raises = false
      begin
        service.vlans.get('OpaqueRef:foo')
      rescue Fog::XenServer::RequestFailed => e
        raises = true if e.message =~ /HANDLE_INVALID/
      end
      raises
    end
  end

end
