Shindo.tests("AWS::Compute | security_group", ['aws']) do

  model_tests(AWS[:compute].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

  tests("a group with trailing whitespace") do
    @group = AWS[:compute].security_groups.create(:name => "foggroup with spaces   ", :description => "   fog group desc   ")
    test("name is correct") do
      @group.name ==  "foggroup with spaces   "
    end

    test("description is correct") do
      @group.description == "   fog group desc   "
    end

    @group.destroy
  end
end
