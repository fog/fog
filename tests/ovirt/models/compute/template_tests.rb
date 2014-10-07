Shindo.tests('Fog::Compute[:ovirt] | template model', ['ovirt']) do

  templates = Fog::Compute[:ovirt].templates
  template = templates.last

  tests('The template model should') do
    tests('have the action') do
      test('reload') { template.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = template.attributes
      attributes = [ :id,
        :name]
      tests("The template model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { template.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Ovirt::Template') { template.kind_of? Fog::Compute::Ovirt::Template }
  end

end
