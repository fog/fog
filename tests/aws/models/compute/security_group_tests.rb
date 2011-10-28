Shindo.tests("Fog::Compute[:aws] | security_group", ['aws']) do

  model_tests(Fog::Compute[:aws].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

  tests("authorize and revoke helpers") do
    @group = Fog::Compute[:aws].security_groups.create(:name => "foggroup", :description => "fog group desc")

    @other_group = Fog::Compute[:aws].security_groups.create(:name => 'fog other group', :description => 'another fog group')

    test("authorize access by another security group") do
      @group.authorize_group_and_owner(@other_group.name)
      @group.reload
      @group.ip_permissions.size == 3
    end

    test("revoke access from another security group") do
      @group.revoke_group_and_owner(@other_group.name)
      @group.reload
      @group.ip_permissions.empty?
    end

    test("authorize access to a port range") do
      @group.authorize_port_range(5000..6000)
      @group.reload
      @group.ip_permissions.size == 1
    end

    test("revoke access to a port range") do
      @group.revoke_port_range(5000..6000)
      @group.reload
      @group.ip_permissions.empty?
    end

    @other_group.destroy
    @group.destroy
  end
end
