Shindo.tests("Fog::Compute[:ovirt] | add_volume request", 'ovirt') do
  compute = Fog::Compute[:ovirt]
  name_base = Time.now.to_i

  tests("Add Volume") do
    response = compute.list_disk_profiles()
    test("should be a kind of OVIRT::DiskProfile") { response.kind_of?  OVIRT::DiskProfile}   
  end

end