Shindo.tests("Fog::Compute[:azure] | image model", ["azure", "compute"]) do

  service = Fog::Compute[:azure]

  tests("The image model should") do
    image  = service.images.first
    tests("have the action") do
      test("reload") { image.respond_to? "reload" }
    end
    tests("have attributes") do
      model_attribute_hash = image.attributes
      attributes = [
        :name,
        :os_type
      ]
      tests("The image model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { image.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
  end

end
