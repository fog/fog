
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

#AfterStep |scenario| do
#  Do something after each step.
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



