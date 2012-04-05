Shindo.tests("Fog::Compute[:libvirt] | create_domain request", 'libvirt') do

  compute = Fog::Compute[:libvirt]
  xml = compute.servers.new( :nics => [{:bridge => "br180"}]).to_xml

  tests("Create Domain") do
    response = compute.create_domain(xml)
    test("should be a kind of Libvirt::Domain") { response.kind_of?  Libvirt::Domain}
  end

  tests("Fail Creating Domain") do
    begin
      response = compute.create_domain(xml)
      test("should be a kind of Libvirt::Domain") { response.kind_of?  Libvirt::Domain} #mock never raise exceptions
    rescue => e
      #should raise vm name already exist exception.
      test("error should be a kind of Libvirt::Error") { e.kind_of?  Libvirt::Error}
    end
  end

end
