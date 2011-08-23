Shindo.tests("Fog::Compute[:aws] | security_group", ['aws']) do

  model_tests(Fog::Compute[:aws].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

  tests("a group with trailing whitespace") do
    @group = Fog::Compute[:aws].security_groups.create(:name => "foggroup with spaces   ", :description => "   fog group desc   ")
    test("name is correct") do
      @group.name ==  "foggroup with spaces   "
    end

    test("description is correct") do
      @group.description == "   fog group desc   "
    end

    @other_group = Fog::Compute[:aws].security_groups.create(:name => 'other group', :description => 'another group')

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

    @other_group.destroy
    @group.destroy
  end
end
