Shindo.tests("Fog::Compute[:digitalocean] | region model", ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  region  = service.regions.first

  tests('The region model should') do
    tests('have the action') do
      test('reload') { region.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = region.attributes
      attributes = [
        :id,
        :name,
      ]
      tests("The region model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { region.respond_to? attribute }
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
