Shindo.tests("Fog::Compute[:libvirt] | define_domain request", 'libvirt') do

  compute = Fog::Compute[:libvirt]
  xml = compute.servers.new().to_xml

  tests("Define Domain") do
    response = compute.define_domain(xml)
    test("should be a kind of Libvirt::Domain") { response.kind_of?  Libvirt::Domain}
  end

end
