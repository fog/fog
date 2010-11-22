Given /^the (\w+) project folder is the current folder/ do  |pn|
  @active_project_folder = File.expand_path(File.dirname(__FILE__) + "/../..")
  Given "a directory named \"#{@active_project_folder}\""
  @working_dir = @active_project_folder
  @project_name = pn.to_s.downcase
  Given "a directory named \"./../#{@project_name}\""
end


