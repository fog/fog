Shindo.tests("Fog::Compute[:ovirt] | vm_create request", 'ovirt') do

  compute = Fog::Compute[:ovirt]
  name_base = Time.now.to_i

  tests("Create VM") do
    response = compute.create_vm(:name => 'fog-'+name_base.to_s, :cluster_name => 'Default')
    test("should be a kind of OVIRT::VM") { response.kind_of?  OVIRT::VM}
  end

  tests("Create VM from template (clone)") do
    response = compute.create_vm(:name => 'fog-'+(name_base+ 1).to_s, :template_name => 'hwp_small', :cluster_name => 'Default')
    test("should be a kind of OVIRT::VM") { response.kind_of?  OVIRT::VM}
  end

  tests("Fail Creating VM") do
    begin
      response = compute.create_vm(:name => 'fog-'+name_base.to_s, :cluster_name => 'Default')
      test("should be a kind of OVIRT::VM") { response.kind_of?  OVIRT::VM} #mock never raise exceptions
    rescue => e
      #should raise vm name already exist exception.
      test("error should be a kind of OVIRT::OvirtException") { e.kind_of?  OVIRT::OvirtException}
    end
  end

end
