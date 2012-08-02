Shindo.tests("Fog::Compute[:aws] | security_group", ['aws']) do

  model_tests(Fog::Compute[:aws].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

  tests("authorize and revoke helpers") do
    @group = Fog::Compute[:aws].security_groups.create(:name => "foggroup", :description => "fog group desc")

    @other_group = Fog::Compute[:aws].security_groups.create(:name => 'fog other group', :description => 'another fog group')
    @other_group.reload

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

    group_forms = [
      "#{@other_group.owner_id}:#{@other_group.group_id}", # deprecated form
      @other_group.group_id,
      {@other_group.owner_id => @other_group.group_id}
    ]

    group_forms.each do |group_arg|
      test("authorize port range access by another security group #{group_arg.inspect}") do
        @other_group.reload
        @group.authorize_port_range(5000..6000, {:group => group_arg})
        @group.reload
        @group.ip_permissions.size == 1
      end

      test("revoke port range access by another security group") do
        @other_group.reload
        @group.revoke_port_range(5000..6000, {:group => group_arg})
        @group.reload
        @group.ip_permissions.empty?
      end
    end

    @other_group.destroy
    @group.destroy
  end
end
