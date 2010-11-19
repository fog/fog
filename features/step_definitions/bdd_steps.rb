
Given /^I intend to BDD with (\w+)$/ do |testing_framework|
  @testing_framework = testing_framework.to_sym
  @active_bdd = true
  case @testing_framework
    when :rspec then
      @active_bdd_folder = File.join(@active_project_folder, "spec")
      @active_bdd_helper = File.join(@active_bdd_folder,"spec_helper.rb")
    when :shindo then
      @active_bdd_folder = File.join(@active_project_folder, "tests")
      @active_bdd_helper = File.join(@active_bdd_folder, "helper.rb")
    else
      @active_bdd_folder = nil
      @active_bdd = false
  end
end

Given /^I do not want cucumber stories$/ do
  @use_cucumber = false
end

Given /^I want cucumber stories$/ do
  @use_cucumber = true
end

When /^I describe Fog's behavior$/ do
  case @testing_framework
    when :rspec then
      @dbb_files = Dir.glob(File.join(@active_bdd_folder,"**","*_spec.rb")) if @active_bdd
    when :shindo then
      @dbb_files = Dir.glob(File.join(@active_bdd_folder,"**","*_tests.rb")) if @active_bdd
    else
      @dbb_files = [] if @active_bdd
  end  
end

Then /^each BDD file requires '(.*)'$/ do |fn|
  if @active_bdd 
    
  end 
end

Then /^each BDD file requires its helper$/ do 
  if @active_bdd then
    @dbb_files.each do |fn|
      Then "the file \"#{fn}\" should contain \"#{Regexp.escape("#{File.basename(@active_bdd_helper, ".rb")}")}\""
    end
    # '(.*)#{@active_bdd_helper}'
  end 
end

Then /^each spec or test file requires '<file>'$/ do
  pending
end

Then /^'(.*)' should have tests for '(.*)'$/ do |file, describe_name|
  @tests_content ||= File.read((File.join(@working_dir, @name, file)))

  assert_match %Q{Shindo.tests("#{describe_name}") do}, @tests_content
end

Then /^'(.+?)' should autorun tests$/ do |test_helper|
  content = File.read(File.join(@working_dir, @name, test_helper))

  assert_match "MiniTest::Unit.autorun", content
end

Then /^cucumber world extends "(.*)"$/ do |module_to_extend|
  content = File.read(File.join(@working_dir, @name, 'features', 'support', 'env.rb'))
  assert_match "World(#{module_to_extend})", content
end

Then /^'(.*)' should define '(.*)' as a subclass of '(.*)'$/ do |file, class_name, superclass_name|
  @test_content = File.read((File.join(@working_dir, @name, file)))

  assert_match "class #{class_name} < #{superclass_name}", @test_content
end

Then /^'(.*)' should describe '(.*)'$/ do |file, describe_name|
  @spec_content ||= File.read((File.join(@working_dir, @name, file)))

  assert_match %Q{describe "#{describe_name}" do}, @spec_content
end

Then /^'(.*)' should contextualize '(.*)'$/ do |file, describe_name|
  @spec_content ||= File.read((File.join(@working_dir, @name, file)))

  assert_match %Q{context "#{describe_name}" do}, @spec_content
end

Then /^'features\/support\/env\.rb' sets up features to use test\/unit assertions$/ do

end

Then /^'features\/support\/env\.rb' sets up features to use minitest assertions$/ do
  content = File.read(File.join(@working_dir, @name, 'features', 'support', 'env.rb'))

  assert_match "world.extend(Mini::Test::Assertions)", content
end

