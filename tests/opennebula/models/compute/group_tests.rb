Shindo.tests('Fog::Compute[:opennebula] | group model', ['opennebula']) do

  groups = Fog::Compute[:opennebula].groups
  group = groups.last

  tests('The group model should') do
    tests('have the action') do
      test('reload') { group.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = group.attributes
      attributes = 
      tests("The group model should respond to") do
        [:name, :id, :to_label].each do |attribute|
          test("#{attribute}") { group.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        [:name, :id].each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::OpenNebula::Group') { group.kind_of? Fog::Compute::OpenNebula::Group }
  end

end
