Given /"(.*)" folder is deleted/ do |folder|
  in_project_folder { FileUtils.rm_rf folder }
end

Then /^file "(.*)" (is|is not) created/ do |file, is|
  in_project_folder do
    fl = Dir.glob(File.expand_path(file)) # Allow wildcard file names
    if is == 'is'
      fl.empty?.should be_false
    else
      fl.empty?.should be_true
    end
  end
end
