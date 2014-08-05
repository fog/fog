Shindo.tests("Fog::DNS[:dreamhost] | Zones Collection", ['dreamhost', 'dns']) do

  service = Fog::DNS[:dreamhost]

  tests('#all') do
    zones = service.zones

    test('should be an array') { zones.is_a? Array }

    test('should not be empty') { !zones.empty? }

    tests('should list Fog::DNS::Dreamhost::Zone') do
      zones.each do |r|
        test("as zone") { r.is_a?(Fog::DNS::Dreamhost::Zone) }
      end
    end
  end

  tests('#get') do
    tests('should fetch a zone') do
      zone = service.zones.get test_domain
      test('should be a Fog::DNS::Dreamhost::Zone') do
        zone.is_a? Fog::DNS::Dreamhost::Zone
      end
    end
  end

end
