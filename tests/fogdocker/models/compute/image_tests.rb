Shindo.tests('Fog::Compute[:fogdocker] | image model', ['fogdocker']) do

  images = Fog::Compute[:fogdocker].images
  image = images.last.reload

  tests('The image model should') do
    tests('have the action') do
      test('reload') { image.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = image.attributes
      attributes = [ :id,
                     :repo_tags,
                     :created,
                     :size
                   ]
      tests("The image model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { image.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        (attributes-[:repo_tags]).each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Fogdocker::image') { image.kind_of? Fog::Compute::Fogdocker::Image }
  end

end
