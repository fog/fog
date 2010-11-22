Given /"(.*)" folder is deleted/ do |folder|
  in_project_folder { FileUtils.rm_rf folder }
end
