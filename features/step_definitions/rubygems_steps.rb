Then /^gem spec key "(.*)" contains \/(.*)\// do |key, regex|
  in_project_folder do
    gem_file = Dir["pkg/*.gem"].first
    gem_spec = Gem::Specification.from_yaml(`gem spec #{gem_file}`)
    #puts gem_spec.methods.sort
    spec_value = gem_spec.send(key.to_s.to_sym)
    spec_value.to_s.should match(/#{regex}/)
  end
end

