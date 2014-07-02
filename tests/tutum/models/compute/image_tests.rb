Shindo.tests('Fog::Compute[:tutum] | image model', ['tutum']) do

  images = Fog::Compute[:tutum].images
  image = images.last.reload

  tests('The image model should') do
    tests('have the action') do
      test('reload') { image.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = image.attributes
      attributes = [ :name,
                     :image_url,
                     :imagetag_set,
                     :is_private_image,
                     :base_image,
                     :cluster_aware,
                     :description,
                     :public_url,
                     :resource_uri,
                     :starred,
                     :docker_registry
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
    test('be a kind of Fog::Compute::Tutum::image') { image.kind_of? Fog::Compute::Tutum::Image }
  end

end
