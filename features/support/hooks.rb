
####################################################################
#
#  Global Hooks
#
####################################################################


####################################################################
#
#  Scenario Hooks
#
####################################################################

# Note: Any 'Background:' is run after any Before hooks.

Before do
#  FakeFS.activate!
end

After do |scenario|
#  FakeFS::FileSystem.clear
#  FakeFS.deactivate!
# Customize as you wish...
# if(scenario.failed?)
#    subject = "[Fog] #{scenario.exception.message}"
#    send_failure_email(subject)
#  end
end


####################################################################
#
#  Step Hooks
#
####################################################################

# stub_chain on a Grit repo's file status clobbers the status so we have
# to regenerate a fresh Grit repo instance.  Currently this does not seem
# to execute...
#AfterStep('@newrepo') do |scenario|
#  @repo = Grit::Repo.new(@active_project_folder)
#end

####################################################################
#
#  Tagged Hooks
#
####################################################################
#
# Only be executed before/after scenarios that are tagged the same
# and after steps in scenarios tagged the same

Before('@fakefs, @vcs') do
  @active_project_folder = File.expand_path(File.dirname(__FILE__) + "/../..")
  @repo = Grit::Repo.new(@active_project_folder)
end

After('@fakefs') do |scenario|
# Customize as you wish...
# if(scenario.failed?)
#    subject = "[Fog] #{scenario.exception.message}"
#    send_failure_email(subject)
#  end
end



