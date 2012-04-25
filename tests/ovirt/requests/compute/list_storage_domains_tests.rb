Shindo.tests('Fog::Compute[:ovirt] | storage_domains request', ['ovirt']) do

  compute = Fog::Compute[:ovirt]

  tests("When listing all storage_domains") do

    response = compute.storage_domains
    tests("The response data format ...") do
      test("it should be a kind of Array") { response.kind_of? Array }
      test("be a kind of OVIRT::StorageDomain") { response.first.kind_of? OVIRT::StorageDomain }
    end
  end
end
