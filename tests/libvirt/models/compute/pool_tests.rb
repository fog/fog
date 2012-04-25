Shindo.tests('Fog::Compute[:libvirt] | interface model', ['libvirt']) do

  pools = Fog::Compute[:libvirt].pools
  pool = pools.last

  tests('The interface model should') do
    tests('have the action') do
      test('reload') { pool.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = pool.attributes
      attributes = [ :uuid, :name, :persistent, :active, :autostart, :allocation, :capacity, :num_of_volumes, :state]
      tests("The interface model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { pool.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Libvirt::Pool') { pool.kind_of? Fog::Compute::Libvirt::Pool }
  end

end
