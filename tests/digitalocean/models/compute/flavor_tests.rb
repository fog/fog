Shindo.tests("Fog::Compute[:digitalocean] | flavor model", ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  flavor  = service.flavors.first

  tests('The flavor model should') do
    tests('have the action') do
      test('reload') { flavor.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = flavor.attributes
      attributes = [
        :id,
        :name,
      ]
      tests("The flavor model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { flavor.respond_to? attribute }
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
