Shindo.tests("Fog::Compute[:opennebula] | vm_create and destroy request", 'opennebula') do

  compute = Fog::Compute[:opennebula]
  name_base = Time.now.to_i
  f = compute.flavors.get 4
  response = {}

  tests("Allocate VM") do
    response = compute.vm_allocate({:name => 'fog-'+name_base.to_s, :flavor => f})
    test("response should be a kind of Hash") { response.kind_of?  Hash}
    test("id should be a one-id (interger)") { response['id'].is_a?  Fixnum}
  end
  tests("Destroy VM") do
    compute.vm_destroy(response['id'])
    vms = compute.list_vms({:id => response['id']})
    test("get vm should be empty") { compute.list_vms({:id => response['id']}).empty?}
  end

  #tests("Create VM from template (clone)") do
  #  response = compute.create_vm(:name => 'fog-'+(name_base+ 1).to_s, :template_name => 'hwp_small', :cluster_name => 'Default')
  #  test("should be a kind of OVIRT::VM") { response.kind_of?  OVIRT::VM}
  #end

  tests("Fail Creating VM - no flavor") do
    begin
      response = compute.vm_allocate({:name => 'fog-'+name_base.to_s, :flavor => nil})
      test("should be a kind of Hash") { response.kind_of?  Hash} #mock never raise exceptions
    rescue => e
      #should raise vm name already exist exception.
      test("error should be a kind of ArgumentError") { e.kind_of?  ArgumentError}
    end
  end
  tests("Fail Creating VM - nil name") do
    begin
      response = compute.vm_allocate({:name => nil, :flavor => f})
      test("should be a kind of Hash") { response.kind_of?  Hash} #mock never raise exceptions
    rescue => e
      #should raise vm name already exist exception.
      test("error should be a kind of ArgumentError") { e.kind_of?  ArgumentError}
    end
  end
  tests("Fail Creating VM - empty name") do
    begin
      response = compute.vm_allocate({:name => "", :flavor => f})
      test("should be a kind of Hash") { response.kind_of?  Hash} #mock never raise exceptions
    rescue => e
      #should raise vm name already exist exception.
      test("error should be a kind of ArgumentError") { e.kind_of?  ArgumentError}
    end
  end

end
