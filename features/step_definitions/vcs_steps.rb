Given /^I configured git sanely$/ do
  ['user.name', 'user.email', 'github.user', 'github.token'].each do |k|
    @repo.config.fetch(k).should_not raise_error(IndexError)
  end
end

When /^the repository status is clean$/ do
  steps %Q{
    Then no files are untracked
      And no files are changed
      And no files are added
      And no files are deleted
  }
end

Then /^no files are (\w+)$/ do |type|
  @repo.stub_chain(:status, type.to_sym, :size).and_return(0)
  eval("@repo.status.#{type}.size").should be 0
end

Then /^'(.*)' was checked in$/ do |file|
  @repo = Grit::Repo.new(@active_project_folder)  # TODO: Moving to a Hook does not  currently work...
  fstat = @repo.status[file]
  fstat.should_receive(:untracked).and_return false
  fstat.should_not be_nil         # "wasn't able to get status for #{file}"
  fstat.untracked.should be_false # "#{file} was untracked"
  fstat.type.should be_nil        # "#{file} had a type. it should have been nil"
end
