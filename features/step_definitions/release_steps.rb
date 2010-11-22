
When /^the updated version file is checked in$/ do
  And "'lib/fog/core/version.rb' was checked in"
end

When /^I run the "(.*)" release task$/ do  |type|
  @rake = Rake::Application.new
  @rake.options.quite = true
  @rake.options.silent = true
  @rake.options.dryrun = true # false to execute Bundler's release task
  @rake.options.trace = false
  Rake.application = @rake
  load "#{@active_project_folder}/Rakefile"
  @task_name = "release:#{type}"
  @task = @rake[@task_name]
  FakeFS.activate!
    ::Fog::Bdd.core_dir
    @version_helper = ::Fog::Bdd.version_helper
    @version_helper.write_version
    @task.execute
  FakeFS.deactivate!
  end

