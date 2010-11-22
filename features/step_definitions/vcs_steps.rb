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
