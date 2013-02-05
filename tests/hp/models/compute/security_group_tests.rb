Shindo.tests("Fog::Compute[:hp] | security_group", ['hp']) do
  # Disabled due to https://github.com/fog/fog/1546
  pending

  model_tests(Fog::Compute[:hp].security_groups, {:name => 'foggroupname', :description => 'foggroupdescription'}, true)

  tests("a group with trailing whitespace") do
    @group = Fog::Compute[:hp].security_groups.create(:name => "   foggroup with spaces   ", :description => "   fog group desc   ")

    test("all spaces are removed from name") do
      @group.name == "   foggroup with spaces   ".strip!
    end

    test("all spaces are removed from description") do
      @group.description == "   fog group desc   ".strip!
    end

    @other_group = Fog::Compute[:hp].security_groups.create(:name => 'other group', :description => 'another group')

    test("authorize access by another security group") do
      sgrule = @group.create_rule(80..80, "tcp", nil, @other_group.id)
      @sg_rule_id = sgrule.body['security_group_rule']['id']
      @group.reload
      s = @group.rules.select {|r| r['id'] == @sg_rule_id unless r.nil?}
      s[0]['id'] == @sg_rule_id
    end

    test("revoke access from another security group") do
      @group.delete_rule(@sg_rule_id)
      @group.reload
      s = @group.rules.select {|r| r['id'] == @sg_rule_id unless r.nil?}
      s.empty?
    end

    @other_group.destroy
    @group.destroy
  end
end
