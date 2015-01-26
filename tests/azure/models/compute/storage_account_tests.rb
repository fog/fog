Shindo.tests("Fog::Compute[:azure] | storage account model", ["azure", "compute"]) do

  storage = storage_account

  tests("The storage account model should") do

    tests("have the action") do
      test("reload") { storage.respond_to? "reload" }
    end
    tests("have attributes") do
      model_attribute_hash = storage.attributes
      attributes = [
        :name,
        :location,
        :status
      ]
      tests("The storage account model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { storage.respond_to? attribute }
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
